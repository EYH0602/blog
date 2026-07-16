---
title: "What (and Why) do we care about on LLM-based test generation"
date: 2026-07-16 13:37:00
tags:
  - LLM
  - software testing
  - test generation
  - fuzzing
  - program analysis
category: research
---

# What (and why) do we care about on LLM-based test generation

If you have known me long enough — back to when I had just started my PhD — you probably remember my research focus as automated software testing with AI. These days my [interests](https://yfhe.net/about/) have drifted a little wider (AI agent in general), but I do still work in this testing direction.

The trend of using LLMs for test generation really started picking up around 2023, with work like [CAT-LM (ASE 2023)](https://squareslab.github.io/materials/raoCATLM.pdf) and [TeCo (ICSE 2023)](https://arxiv.org/abs/2302.10166) training models on test code, and UniTSyn was an early entry in the direction of aligning tests with the functions they test. So what follows is a personal opinion, from someone who has worked in this direction since near its beginning. All these years I have been thinking about and chasing a single claim, and each of my papers is one more attempt to make it true. This post is that claim, stated as plainly as I can.

## The claim

Here it is, up front, in one sentence:

> **Generative AI is *necessary*, not merely convenient, for software testing — because there is a class of bug, i.e. functional and logical bugs,
that emits no mechanical signal (no crash, no sanitizer trip) and is therefore invisible to traditional testing (fuzzing, differential testing, ...) by construction. 
Catching it requires inferring *intent* from semantics (natural language or code), which is exactly what LLMs are for.**

That is the whole argument. Two other beliefs bracket it, and I will make them along the way, but they are the premise and the corollary, not the point:

- *Premise:* a generated test is only worth anything if it encodes what the code was supposed to do and can fail when the code does something else — not a test contorted around the current implementation just to make it pass. Compiling, running, covering lines, passing — all necessary, none of them the goal.
- *Corollary:* automated bug detection presupposes a definition of the bug you are hunting — you cannot mechanically find what you cannot state. So the field's real open problem is that we still define functional bugs by absence ("no crash," "silent," "machine un-auditable"). We need a sound, positive definition of what a functional bug is — and until we have one, the LLM is a stopgap oracle standing in for a specification we have not yet learned to write down.

The rest of this post is why I believe the central claim, and how three years of my own work has been circling it.

## How the field got here

It helps to see the shape of the last few years, because the ambition has kept scaling up and it colors what "good" is supposed to mean. And it happens to track my own path into the problem, so I will tell it that way.

It started small — narrower than most people remember. Before the LLM wave, the neural-testing task was **assertion generation**: [ATLAS (ICSE 2020)](https://arxiv.org/abs/2002.05800) took a focal method and a human-written test with its single assert statement deleted, and tried to predict that one line. The human wrote the entire test body; the model filled one blank. [AthenaTest (2020)](https://arxiv.org/abs/2009.05617) widened the aperture slightly to a whole test *method* from a focal method, and a [transformer version of the assert task landed at AST 2022](https://arxiv.org/abs/2009.05634). Then [TeCo (ICSE 2023)](https://arxiv.org/abs/2302.10166) formalized **test completion** — given the statements so far plus the code under test, predict the next test statement — the line-by-line autocomplete framing. All of it is fill-in-the-blank: the human owns the scaffolding, the model completes a piece. My own entry point sat right next to this era but pointed sideways: [*Understanding Programs by Exploiting (Fuzzing) Test Cases* (ACL Findings 2023)](https://arxiv.org/abs/2305.13592) used fuzzing-generated inputs to show a model how a function actually *behaves*, not just how its tokens read. That instinct — that dynamic behavior is a teaching signal — is the seed everything after it grows from.

The next step was **whole test function and test file generation** — hand the model a function and get back a complete, compilable test. [CAT-LM (ASE 2023)](https://squareslab.github.io/materials/raoCATLM.pdf) pushed to file-level generation by pretraining on aligned code-and-test files, and a wave of coverage-chasers followed: [TestPilot](https://arxiv.org/abs/2302.06527), [ChatUniTest](https://arxiv.org/abs/2305.04764), [CoverUp](https://arxiv.org/abs/2403.16218), [HITS](https://arxiv.org/abs/2408.11324), nearly all of them headlining one number — *we beat EvoSuite on coverage*. This is also where most benchmarks still live ([TestGenEval](https://arxiv.org/abs/2410.00752), [SWT-Bench](https://arxiv.org/abs/2406.12952)). It is where the training-data problem I worked on became acute: to write a whole test the model has to actually understand what the function does, not just pattern-match a nearby assertion. My first two papers are aimed straight at that. [UniTSyn (ISSTA 2024)](https://arxiv.org/abs/2402.03396) fixes the data — 2.7M tests correctly paired with their focal functions across five languages, mined language-agnostically through the Language Server Protocol. [FuzzAug (EMNLP Findings 2025)](https://arxiv.org/abs/2406.08665) fixes the diversity — folding coverage-guided fuzzing inputs back into training so the tests exercise varied behavior while keeping their human-written oracle. Data, then diversity.

Most recently the frame has widened again, to **agentic and continuous testing** — systems that explore a whole library, generate sequences of calls, run them, repair failures, and hunt for real bugs on their own, closer to what [OSS-Fuzz](https://github.com/google/oss-fuzz) does for crashes but aimed at functional correctness. The tell is that the industrial work has quietly stopped optimizing coverage: Meta's [TestGen-LLM (FSE 2024)](https://arxiv.org/abs/2402.09171) only keeps a generated test if it *reliably passes and strictly increases coverage*, and its successor [ACH (FSE 2025)](https://arxiv.org/abs/2501.12862) drops coverage entirely to generate tests that *kill targeted mutants* — a test that catches a planted fault, not a test that runs. [KNighter (SOSP 2025)](https://arxiv.org/abs/2503.09002) let an LLM synthesize static-analysis checkers and turned up 92 long-latent Linux-kernel bugs and 30 CVEs. The pivot across all of it is the same: *find a real bug, don't just produce a passing test.* [LISA (ISSRE 2026)]() is my attempt to sit here — an automated, iterative pipeline that generates API sequences, inserts documentation-grounded oracles, verifies them against a reference build, and reports bug candidates for silent functional bugs.

Each rung up that ladder raises the same question in a louder voice: as the machine takes over more of the loop, *what is the thing it is actually supposed to produce?* That is the question this post is about.

## The wrong enemy

Most of the LLM-based testing literature optimizes the wrong thing. A generated test that compiles, runs, covers 80% of the branches, and asserts `assert(ptr != NULL)` scores beautifully on every standard benchmark and catches nothing. Pass rate and coverage are necessary. They are not the goal. They are table stakes that we have mistaken for the finish line.

Look at what the dominant benchmarks actually measure. [TestEval](https://arxiv.org/abs/2406.04531) reports pass@k. [SWT-Bench](https://arxiv.org/abs/2406.12952) reports pass rate and coverage. The coverage-chasing tools — [TestPilot](https://arxiv.org/abs/2302.06527), [ChatUniTest](https://arxiv.org/abs/2305.04764), [CoverUp](https://arxiv.org/abs/2403.16218), [HITS](https://arxiv.org/abs/2408.11324) — headline one number: *we beat EvoSuite on line coverage*. None of these ask the question that actually matters: can the generated tests detect a fault?

[TestGenEval (ICLR 2025)](https://arxiv.org/abs/2410.00752) is a welcome step. It is the first large-scale benchmark to report **mutation score** alongside coverage — injecting synthetic faults into the code and measuring whether the generated tests catch them. The results are sobering: GPT-4o achieves 35.2% coverage but only 18.8% mutation score, meaning the vast majority of its generated assertions are too weak to notice even a simple code change. Mutation score is empirically far more correlated with real fault detection than coverage ([Just et al., 2014](https://dl.acm.org/doi/10.1145/2635868.2635929); [Papadakis et al., 2018](https://ieeexplore.ieee.org/document/8354438)), and it is much harder to game — a test must actually discriminate non-buggy code from mutated code to score well.

But even mutation score does not close the gap entirely. Mutation testing tells you whether a test can detect *synthetic* perturbations — a flipped operator, a deleted statement, a swapped constant. It does not tell you whether the test can catch a *real functional bug*: a wrong algorithm, a misunderstood specification, a silently incorrect optimization like the SQLite `0 OR 2 → 2` case I describe later. The mutants are mechanical; the bugs we care about are semantic. So mutation score is a better proxy than coverage, but it is still a proxy — and the field still lacks a benchmark that directly measures a generated test suite's ability to uncover real, historical, functional bugs in the wild.

The goal of testing, from the start and beyond, is to ensure *the code does what it is supposed to do*. 
A test that passes and covers lines but does not encode the intended behavior is a test that cannot fail when the code does something else.
Everything I care about follows from that one sentence.

## What makes the AI necessary, not just convenient, for software testing?

This is the question the whole field should be forced to answer, because most papers quietly answer a weaker one.

The common pitch for LLM test generation is a **productivity** pitch: it is cheaper than writing tests by hand, more maintainable than search-based generators like EvoSuite, more readable than a fuzzer's byte soup. All true. All beside the point. A productivity argument invites an easy rebuttal: so is a better fuzzer, so is a better template engine. If AI is only *convenient*, it is competing on a crowded axis where it might lose.

The argument I actually believe is a **capability** argument, and it turns on one word: **signal**.

Every traditional automated testing method can only find bugs that emit a signal it can mechanically detect.

- **Fuzzing** needs a crash, a hang, or a sanitizer trip (ASan, UBSan, MSan). Its oracle is "did the process misbehave at the machine level." A function that returns `2` when it should return `1` runs perfectly, corrupts no memory, exits zero. Fuzzing sprints right past it.
- **Differential testing** needs a reference implementation to disagree with. Most library code has no golden twin, and where a twin exists, both copies often share the same wrong assumption. It just converts the oracle problem into "go find me a second oracle," which usually does not exist.

Both techniques are, for functional correctness, fundamentally **un-oracled**. They detect deviation from a mechanical invariant (memory safety, crash-freedom, cross-implementation agreement). They never detect deviation from *intent*.

Now the class of bugs that produces no mechanical signal at all: the functional and logical bugs. In LISA I hit one in SQLite where the query optimizer evaluated the expression `0 OR 2` as `2` instead of the boolean `1`. Valid CPU instructions, clean memory, correct exit code, wrong answer. In LISA's own words this class is **machine un-auditable**. You can throw a thousand CPU-years of libFuzzer at that expression and it will never flag it, because the class is *defined by the absence of the signal fuzzing depends on*. No fuzzer improvement reaches it. The limitation is not the tool, it is the category.

So what can catch it? Something that knows the code was supposed to return a boolean. That knowledge does not live in the binary. It lives in the documentation, the API name, the surrounding code, the comments — natural language written by and for humans. The oracle has to be *inferred from intent*, and intent lives in exactly the medium generative models were built to read.

That is why the AI is necessary and not merely convenient. There is a class of bug that no amount of fuzzing compute can reach, defined precisely by the missing signal, and closing it requires inferring intent from natural language. This is not a temporary gap in the tooling. It is structural.

One caveat I insist on, because overclaiming here is cheap and wrong: **AI does not replace fuzzing, it covers a disjoint region.** In LISA's own results OSS-Fuzz caught a libpng crash that LISA missed. Sanitizer-detectable bugs belong to fuzzing. Signal-less logic bugs belong to generative oracles. The two scopes are complementary. The honest and still-strong claim is that AI is necessary for a region fuzzing *cannot enter*, not that it wins everywhere.

## What I actually care about in a generated test

From the signal argument, the quality axes fall out. When I judge a generated test, I ask:

1. **Does it encode intent as a checkable oracle?** Not "is there an assertion" but "does the assertion express what this function is supposed to do." This is the hard part and the whole game. `assert(ptr != NULL)` is not an oracle, it is a formality.
2. **Is the oracle grounded in something real?** I never trust raw model output. It has to be tied to a checkable signal: the focal function's actual behavior, the program's runtime behavior under real inputs, the documented contract, a reference build.
3. **Are we measuring the right thing?** Accuracy (does the oracle match ground truth) and completeness (does it exercise the behavior) as separate axes, plus the density of *meaningful* verifications, plus detection of real historical bugs. A single pass-rate number hides emptiness, so I refuse to report only that.

## The three-year arc is one argument

Read together, my three papers are not three tools. They are one claim, built up in three moves, each fixing the previous one's residual gap. The through-line is: *manufacture intent-based oracles, at scale, grounded in program analysis.*

**UniTSyn (2024): the model must know what it is testing.** You cannot generate an intent-oracle if the model never learned what intent attaches to. LLMs trained on undifferentiated code cannot reason about expected behavior. So I paired every test with its focal function, at scale, across five languages using the Language Server Protocol to avoid fragile per-language heuristics. The prerequisite for an oracle is knowing what you are asserting on.

**FuzzAug (2025): semantics alone lack diversity, behavior alone lacks meaning.** Meaningful tests are scarce; fuzzing inputs are diverse but meaningless. So I did the deliberately ironic thing: I took fuzzing, the canonical no-oracle technique, and used its coverage-guided inputs to feed *semantically valid* test templates that keep the assert. Strip fuzzing of its weakness (meaningless inputs, no oracle), keep its strength (diverse behavior), fuse it with the model's oracle. Dynamic analysis in service of intent, not in place of it.

**LISA (2026): even a meaningful test is useless without a meaningful oracle, and functional bugs do not crash.** The frontal assault. Name the enemy (silent functional bugs), name why fuzzing fails (no signal), and build the intent-oracle explicitly: documentation-grounded invariants, inserted at chunk boundaries, verified against a reference build, as *weaker-but-robust* oracles for non-testable programs. The key design move is **decoupling** exploration from oracle construction. And the honesty clause is deliberate: LISA emits high-confidence bug candidates for a developer to confirm. It mitigates the oracle problem, it does not solve it.

## Where I think the field should go: a sound definition of the bug

Here is the part I have become most opinionated about, and it is the uncomfortable one.

We do not have a definition of what a functional or logical bug *is*. We define it by absence — no crash, no memory error, no sanitizer signal, "silent," "machine un-auditable." A definition by negation is a research dead end. You cannot measure recall against a class you cannot characterize. You cannot prove a detector is complete over a class you can only point at. And so every detector we build, mine included, is reduced to inferring intent probabilistically and hoping.

From a PL, SE, and security standpoint, I think the real work ahead is to find a **sound, positive definition of what logical and functional bugs look like.** A functional bug is a divergence between a program's semantics and its specification. For crashes the specification is implicit and universal — do not corrupt memory, do not hang — which is exactly why it is mechanically checkable. For functional bugs the specification is program-specific and almost always unwritten. So a sound definition really means a principled theory of *where the specification lives and what form it takes*: documented contracts, algebraic and metamorphic relations, refinement types, the previous version as the spec for a regression. Invariants, the ones LISA leans on, are one partial and honest attempt at this, but they are a start, not the answer.

This reframes why the LLM is necessary in a way I find clarifying. **The LLM is necessary today precisely because the definition is missing.** In its absence we outsource intent-inference to a model trained on human intent. But that should be a stopgap and a discovery tool, not the destination. The genuinely interesting possibility is that the model can help us *find* the definition: surface candidate contracts and invariants at scale, which we then filter, formalize, and turn into something a machine can check soundly. LISA already gestures at this by reconciling Daikon's mined candidates against documentation. The north star is not a perpetually better guesser. It is a characterization of the bug class precise enough that we can quantify over it. Until we have that, we are catching functional bugs by feel. I would like the field to stop being satisfied with that.

That is what I care about, and why. The tests are just how I keep testing the claim.
