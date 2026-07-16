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

I have written one paper a year on LLM-based test generation for three years running: UniTSyn (ISSTA 2024), FuzzAug (EMNLP 2025), and LISA (ISSRE 2026). People ask why I keep circling the same topic. The honest answer is that I have been chasing a single claim, and each paper is one more attempt to make it true. This post is that claim, stated as plainly as I can.

## The wrong enemy

Most of the LLM-testing literature optimizes the wrong thing. A generated test that compiles, runs, covers 80% of the branches, and asserts `assert(ptr != NULL)` scores beautifully on every standard benchmark and catches nothing. Pass rate and coverage are necessary. They are not the goal. They are table stakes that we have mistaken for the finish line.

The goal is a test that encodes *what the code was supposed to do* and can fail when the code does something else. Everything I care about follows from that one sentence.

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
