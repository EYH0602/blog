---
title: "What (and Why) We Care About in LLM-Based Test Generation"
date: 2026-07-16 13:37:00
tags:
  - LLM
  - software testing
  - test generation
  - fuzzing
  - program analysis
category: research
---

# What (and Why) We Care About in LLM-Based Test Generation

*TL;DR: AI-based testing should target the bugs traditional testing cannot find — not the ones it already catches, more cheaply.*

For years I pitched my own research the way everyone does: LLMs write tests faster than you can by hand, cleaner than EvoSuite, more readable than a fuzzer's byte soup. All true. And all, I now think, beside the point.

The moment it broke for me was a single expression in SQLite. The query optimizer evaluated `0 OR 2` and returned `2` — not the boolean `1` it was supposed to. Valid CPU instructions, clean memory, correct exit code, wrong answer. You could throw a thousand CPU-years of libFuzzer at that line and it would never flag it, because there is nothing for a fuzzer to trip over: no crash, no sanitizer trip, no signal at all. The bug is invisible *by construction*.

![The SQLite optimizer evaluates `0 OR 2` as `2`. Every mechanical signal a fuzzer watches — crash, sanitizer, exit code — stays green. The bug is invisible by construction.](/images/sqlite_silent_bug.png)

If a bug like that exists — and entire classes of them do — then the productivity pitch is the wrong pitch. Convenience is a crowded axis where the competition is nearly free. The argument worth making is a **capability** argument: there is a class of bug that no traditional method can reach, not by weakness but by category, and catching it requires inferring *intent* from natural language. That is exactly, and only, what LLMs are for.

I have been circling this one claim for three years, since the start of my PhD in automated software testing with AI. (My [interests](https://yfhe.net/about/) have since drifted wider, toward AI agents in general, but I still work this direction.) Each of my papers is one more attempt to make the claim true. This post is that claim, stated as plainly as I can.

## The claim

Here it is, up front, in one sentence:

> **Generative AI is *necessary*, not merely convenient, for software testing. Functional and logical bugs emit no mechanical signal — no crash, no sanitizer trip — so traditional methods like fuzzing and differential testing are blind to them by construction. Catching them requires inferring *intent* from semantics, and that is exactly what LLMs are for.**

Two other beliefs bracket it — the premise and the corollary, not the point:

- *Premise:* a generated test is only worth anything if it encodes what the code was supposed to do and can fail when the code does something else. Compiling, running, covering lines, passing — all necessary, none of them the goal.
- *Corollary — the **definition-by-absence trap**:* automated bug detection presupposes a definition of the bug you are hunting — you cannot mechanically find what you cannot state. The field still defines functional bugs by absence ("no crash," "silent," "machine un-auditable"), so the LLM is a stopgap oracle standing in for a specification we have not yet learned to write down.

The rest of this post is why I believe it.

## The coverage illusion: the field is optimizing the wrong number

Most of the LLM-based testing literature is chasing what I will call the **coverage illusion**. A generated test that compiles, runs, covers 80% of the branches, and asserts `assert(ptr != NULL)` scores beautifully on every standard benchmark and catches nothing. Pass rate and coverage are table stakes that we have mistaken for the finish line.

You can watch the illusion take hold in three acts. The neural-testing task started as fill-in-the-blank — [ATLAS (ICSE 2020)](https://arxiv.org/abs/2002.05800) predicting a single deleted assert, [TeCo (ICSE 2023)](https://arxiv.org/abs/2302.10166) autocompleting the next test statement — the human owning the scaffolding, the model filling a hole. Then came whole-test generation and a wave of coverage-chasers — [TestPilot (TSE 2024)](https://arxiv.org/abs/2302.06527), [ChatUniTest (FSE Companion 2024)](https://arxiv.org/abs/2305.04764), [CoverUp (FSE 2025)](https://arxiv.org/abs/2403.16218), [HITS (ASE 2024)](https://arxiv.org/abs/2408.11324) — nearly all headlining one number: *we beat EvoSuite on coverage*. The benchmarks ossified around the same metrics: [TestEval (NAACL 2025)](https://arxiv.org/abs/2406.04531) reports pass@k, [SWT-Bench (NeurIPS 2024)](https://arxiv.org/abs/2406.12952) pass rate and coverage. None of them ask the question that actually matters: can the generated tests detect a fault?

The tell is that industry has already quietly seen through the illusion. Meta's [TestGen-LLM (FSE 2024)](https://arxiv.org/abs/2402.09171) only keeps a test that reliably passes and strictly increases coverage — and its successor [ACH (FSE 2025)](https://arxiv.org/abs/2501.12862) drops coverage entirely, keeping only tests that *kill targeted mutants*. [KNighter (SOSP 2025)](https://arxiv.org/abs/2503.09002) had an LLM synthesize static-analysis checkers and turned up 92 long-latent Linux-kernel bugs and 30 CVEs. The pivot is unmistakable: *find a real bug, don't produce a passing test.*

The academic benchmarks are starting to follow. [TestGenEval (ICLR 2025)](https://arxiv.org/abs/2410.00752) is the first at scale to report **mutation score** alongside coverage, and the numbers are damning: GPT-4o hits 35.2% coverage and 18.8% mutation score. Read those together — the tests run through a third of the code and catch fewer than a fifth of deliberately planted faults. The vast majority of generated assertions are too weak to notice even a simple code change. And mutation score, though far better correlated with real fault detection than coverage ([Just et al., FSE 2014](https://dl.acm.org/doi/10.1145/2635868.2635929)), is still a proxy: mutants are mechanical perturbations, while the bugs we care about are semantic — a wrong algorithm, a misunderstood spec, a silently incorrect optimization like SQLite's `0 OR 2 → 2`. The field still lacks a benchmark that directly measures whether a generated suite can uncover real, historical, functional bugs in the wild.

The goal of testing has never changed: ensure *the code does what it is supposed to do*. Coverage and pass rate can both look perfect while that goal goes entirely unmet. Everything I care about follows from that one sentence.

## Why no amount of compute solves this

The whole argument turns on one word: **signal**. Every traditional automated testing method can only find bugs that emit a signal it can mechanically detect.

- **Fuzzing** needs a crash, a hang, or a sanitizer trip. Its oracle is "did the process misbehave at the machine level." And against that class of bug, a fuzzer is genuinely unbeatable: it is the [infinite monkey theorem](https://en.wikipedia.org/wiki/Infinite_monkey_theorem) running on silicon — one of the first fuzzers was literally Steve Capps' 1983 ["Monkey"](https://www.folklore.org/Monkey_Lives.html), feeding random events to a pre-release Macintosh until it crashed. Given enough time, the monkey finds every crash with probability 1, on one CPU core, nearly for free. That is the competitor you face if your only pitch is speed and cost. But a function that returns `2` when it should return `1` runs perfectly, corrupts no memory, exits zero. The monkey sprints right past it — not for a shortage of compute, but because the class is *defined by the absence of the signal fuzzing depends on*.
- **Differential testing** needs a reference implementation to disagree with. Most library code has no golden twin, and where a twin exists, both copies often share the same wrong assumption. It converts the oracle problem into "go find me a second oracle," which usually does not exist.

Both techniques are, for functional correctness, fundamentally **un-oracled**. They detect deviation from a mechanical invariant; they never detect deviation from *intent*. So what can catch the SQLite bug? Something that knows the code was supposed to return a boolean — knowledge that does not live in the binary but in the documentation, the API name, the comments: natural language written by and for humans. The oracle has to be *inferred from intent*, and intent lives in exactly the medium generative models were built to read. The gap is structural, not a temporary shortfall in tooling.

To be precise about the boundary — because overclaiming here is cheap and wrong — AI does not replace fuzzing; it covers a disjoint region. In LISA's libpng results, OSS-Fuzz caught a use-after-free that LISA missed, while LISA caught silent logic errors OSS-Fuzz ran straight past. The two tools failing in opposite directions is the clearest picture of the split: AI is necessary for a region fuzzing *cannot enter*, not a winner everywhere.

![Two territories, little overlap. Fuzzers own memory-safety crashes (left); intent-oracles own silent logic errors (right). On libpng, each caught what the other missed — the split is the point, not a contest.](/images/disjoint_testing.png)

From the signal argument, the quality bar for a generated test falls out directly. I ask three things: does it encode intent as a checkable oracle (`assert(ptr != NULL)` is a formality, not an oracle); is the oracle grounded in something real (runtime behavior, a documented contract, a reference build — never raw model output); and are we measuring accuracy and completeness of the oracles rather than a single pass-rate number that hides emptiness.

## Three obstacles an intent-based tester must solve

The papers below are examples, not the thesis. I backed into the claim above one obstacle at a time, and what matters are the three general obstacles they exposed, not the tools that exposed them: attaching a test to the behavior it is about, adding behavioral diversity without losing the oracle, and separating exploration from knowing what the answer should be. Each of my papers is one attempt at one of them.

**The first obstacle is attachment: a model cannot infer a meaningful oracle unless it knows which behavior the test is asserting about.** Models trained on undifferentiated code see tests and functions as unrelated token streams — they have no notion that this assertion is *about* that function. [UniTSyn (ISSTA 2024)](https://arxiv.org/abs/2402.03396) was our attempt to fix that training signal: 2.7M tests correctly paired with their focal functions across five languages, mined language-agnostically through the Language Server Protocol.

**The second obstacle is diversity without oracle loss: human tests carry intent but explore narrowly, while fuzzing explores broadly without knowing what outputs are correct.** [FuzzAug (EMNLP 2025)](https://arxiv.org/abs/2406.08665) was one attempt to combine those strengths — the deliberately ironic move of taking fuzzing, the canonical *no-oracle* technique, stripping its weakness (meaningless inputs), keeping its strength (diverse behavior), and fusing it onto the human-written oracle. That was the first time I framed dynamic analysis as being *in service of* intent rather than a replacement for it.

**The third obstacle is separating exploration from judgment: reaching the deep stateful place where a bug lives and knowing what the answer should have been once you arrive are different tasks.** Even a meaningful test on diverse inputs is useless if nothing tells you the output is wrong — and silent functional bugs never do. [LISA (ISSRE 2026)]() is our attempt to address the oracle problem directly by testing that decomposition: it **decouples** exploration from oracle construction, because the reason monolithic tools emit `assert(ptr != NULL)` is that they ask one pass to do both. Split apart, the intent-oracle does its job: documentation-grounded invariants, verified against a reference build, catch 48% of real historical functional bugs where crash-oriented OSS-Fuzz manages 8% — exactly the gap the signal argument predicts. LISA emits high-confidence bug *candidates* for a developer to confirm, because it validates its invariants against documentation rather than proving them. It mitigates the oracle problem; it does not solve it.

Read in order, the three are not three tools. They are one claim assembled backward from its symptoms: fix the data, then the diversity, then the oracle — and what falls out is the general requirement, *manufacture intent-based oracles, at scale, grounded in program analysis.* The gap LISA only mitigates is the last section.

## The definition we're missing

Here is the part I have become most opinionated about, and it is the uncomfortable one.

We do not have a definition of what a functional or logical bug *is*. We define it by absence — no crash, no sanitizer signal, "silent," "machine un-auditable." That is the definition-by-absence trap, and a definition by negation is a research dead end. You cannot measure recall against a class you cannot characterize. You cannot prove a detector complete over a class you can only point at. Every detector we build, mine included, is reduced to inferring intent probabilistically and hoping.

The real work ahead is an **operational, positive definition of what logical and functional bugs look like.** A functional bug is a divergence between a program's semantics and its specification. For crashes the specification is implicit and universal — do not corrupt memory, do not hang — which is exactly why it is mechanically checkable. For functional bugs the specification is program-specific and almost always unwritten. So an operational definition really means a principled theory of *where the specification lives and what form it takes*: documented contracts, algebraic and metamorphic relations, refinement types, the previous version as the spec for a regression.

This reframes why the LLM is necessary in a way I find clarifying. **The LLM is necessary today precisely because the definition is missing.** In its absence we outsource intent-inference to a model trained on human intent. But that should be a stopgap and a discovery tool, not the destination. The genuinely interesting possibility is that the model helps us *find* the definition: surface candidate contracts and invariants at scale, which we then filter, formalize, and turn into something a machine can check soundly. LISA gestures at this by reconciling Daikon's mined candidates against documentation. Two recent papers from Hao Chen's group push the idea furthest, and both are worth reading as *attempts* — not as the definition arriving. [SpecAuditor (S&P 2026)](https://haochen.org/publications/lin2026specauditor.pdf) mines an `Entity–Constraint` specification from each historical patch — the previous version as the spec — validates it differentially, generalizes it to code that shares the behavior but not the syntax, and found 71 long-latent kernel bugs. [BugAuditor (USENIX Security 2026)](https://yuuoniy.github.io/files/BugAuditor.pdf) looks at a different place the specification hides: the defensive code developers already wrote. It infers the intended defensive pattern around a security-sensitive operation and flags every context that handles the same operation inconsistently — consistency itself as the spec — confirming 54 long-latent kernel bugs, 20 since fixed and 2 with CVEs.

But it is worth being honest about how far this is from a *definition*. Both papers work by narrowing the target to a slice where a proxy specification happens to be recoverable — patch-derived constraints, security-sensitive operations — and both still lean hard on a human to finish the job. BugAuditor emits 675 raw reports to surface those 54 bugs, roughly ten person-hours of manual triage, and 79% of its false positives trace to the LLM simply misjudging whether an inconsistency is a bug. The mined spec is approximate; the oracle stays probabilistic and human-confirmed. That is the stopgap working as a discovery tool — which is exactly what it should be — not a machine-checkable account of the bug class. The question underneath is one I have gone back and forth on with people in that group and still cannot answer cleanly: *what, precisely, is a functional bug?* These are the field probing where a specification might live, not yet writing one down.

The north star is not a perpetually better guesser. It is a characterization of the bug class precise enough that we can quantify over it. Until we have that, every functional bug we catch, we catch by feel — and I would like the field to stop calling that a method.
