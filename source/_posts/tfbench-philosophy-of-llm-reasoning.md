---
title: "The Reasoning Gap"
date: 2026-02-24 
tags:
  - research
  - philosophy
  - math
  - LLM
  - type theory
category: Research
---

# The Reasoning Gap

Take a function called `map`. Ask a frontier LLM to infer its type. It nails it --- 90% accuracy.

Drop the name. Call it `f3`. The reasoning collapses.

Change the symbols. Rename the types from `Int` and `Bool` to `T1` and `T2`. The reasoning collapses.

Same logic, same structure, same types flowing through it. **Nothing changed except the labels.** That is the core finding of [TF-Bench](https://yfhe.net/publications/he2025tfbench.pdf), our benchmark published at [NeurIPS 2025](https://openreview.net/forum?id=IA9RmaP0aw). But this post is not about the benchmark. It is about the idea behind it --- an idea borrowed from the philosophy of mathematics, routed through category theory and type theory, that reframes what "reasoning" means and why we are measuring it wrong.

The AI community has a reasoning problem. Not a technical one --- a conceptual one. OpenAI's o1, DeepSeek-R1, Claude with extended thinking --- test-time compute has become the new scaling paradigm. The models can think step by step. They can plan. They produce chains of inference that look strikingly human. Everyone is calling it reasoning.

But looking like reasoning and _being_ reasoning are two very different things.

## Two Kinds of Semantics

What does a compiler see when it reads code?

Types. Data flow. Function composition. The structural logic of the program. Rename every variable to `x1`, `x2`, `x3` --- nothing changes. The program compiles and runs identically. Call this **program semantics**.

Now what does a human see? Meaningful variable names, comments, naming conventions --- the natural language layer that helps us _understand_ code. Call this **cognitive semantics**. It has zero effect on execution.

A function named `filterEvenNumbers` and one named `f7` can be structurally identical. The compiler does not care.

**LLMs care a great deal.**

This is the gap. Models understand code the way a reader does, not the way a compiler does. They operate in the cognitive semantics space --- and when you strip that away, the illusion of understanding breaks.

The observation itself is not new. But the implications go deeper than most people realize, and the framing I use comes from an unlikely source.

## The Foundational Crisis and What It Teaches Us

Here is a question most people never ask: if every proposed foundation for mathematics has cracked, what are mathematicians actually _doing_?

Set theory met Russell's paradox. Hilbert's program was shattered by Gödel. Each proposed bedrock collapsed under its own weight. This sounds like an intellectual dead end. It is actually one of the most important stories in the history of human thought.

I encountered this question through [Professor Elaine Landry](https://philosophy.ucdavis.edu/people/elaine-landry)'s work, and it changed how I think about intelligence testing. Her answer is what she calls **as-ifism** --- methodological as-if realism:

> In mathematics, we treat our hypotheses _as if_ they were true first principles, and consequently, our objects _as if_ they existed, and we do this for the purpose of solving problems.

The mathematician does not need to commit to whether numbers "really exist." She takes her axioms _as if_ they were true and reasons downward to a conclusion. Start from assumptions. Apply derivation rules. Arrive at results. **Truth comes first; existence follows.**

This is not Platonism (objects exist independently) or formalism (it is all symbol manipulation). It is **methodological structuralism** --- and it sidesteps the metaphysical debates that have paralyzed the field for decades. As Landry puts it: "mathematics is a language; it talks about objects without being about them."

She traces this reading back to Plato himself, arguing in [_Plato Was Not a Mathematical Platonist_](https://doi.org/10.1017/9781009313797) that the standard story is wrong. Plato's mathematician uses the hypothetical method; the philosopher uses the dialectical method. Confusing them is, Landry argues, **the original sin of 2,400 years of philosophy of mathematics** --- a conflation of metaphysics with method that persists today.

Why does this matter for AI? Because we are making the exact same mistake.

## Category Theory as the Right Lens

If mathematical objects are just positions in structures, what language do we use to talk about the structures themselves?

Category theory. But not as yet another metaphysical foundation --- Landry views it as a **methodological metalanguage**: a framework for talking about structured systems (sets, groups, topological spaces, deductive systems) without committing to what those systems ultimately _are_. The category axioms are taken _as if_ they were first principles. They are hypotheses set up for the purpose of solving problems.

This is **methodological structural as-ifism**: what matters is the _method_ --- reasoning from structure alone --- not whether structures "really exist."

So what does this tell us?

**Mathematical reasoning operates on structure, not on names.** A group theorist who proves a theorem about group $G$ does not need to know what $G$ "really is." She needs only its axioms and the derivation rules. If her proof breaks when you rename $G$ to $H$, she does not understand group theory.

She recognizes $G$.

## From Categories to Types

Here is the punchline of 80 years of logic, type theory, and category theory --- compressed into one table.

The Curry-Howard-Lambek correspondence establishes a three-way equivalence:

| **Logic**                       | **Type Theory**             | **Category Theory** |
| ------------------------------- | --------------------------- | ------------------- |
| Propositions                    | Types                       | Objects             |
| Proofs                          | Programs                    | Morphisms           |
| Implication ($A \Rightarrow B$) | Function type ($A \to B$)   | Exponential object  |
| Conjunction ($A \wedge B$)      | Product type ($A \times B$) | Categorical product |

A function of type $A \rightarrow B$ is simultaneously a proof that $A$ implies $B$ _and_ a morphism from object $A$ to object $B$. Why? Because to implement a function $A \rightarrow B$, you must construct a valid output of type $B$ from every input of type $A$ --- and that construction _is_ a proof that the implication holds. The implementation _is_ the proof. The type signature _is_ the proposition. This is not metaphor. It is a mathematical correspondence --- and the foundation of Haskell's type system.

The connection to Landry's program is direct. If reasoning means operating on structure, type theory gives us a formal system where we can **test that precisely**. Here is the translation:

- **Type dependencies** = **axioms** --- the assumptions we take _as if_ they were first principles.
- **Function implementation** = **proof** --- a morphism in the relevant category.
- **Type inference** = **natural deduction** --- deriving the type signature from those axioms.

And here is why this works for evaluating LLMs: **code is in-distribution.** Models have seen enormous amounts of Haskell, Python, Java. They are not in-distribution for symbolic logic notation. Type inference gives us a way to test formal deductive reasoning within a domain the models can actually engage with.

That is [TF-Bench](https://github.com/SecurityLab-UCD/TF-Bench).

## Why This Matters for AI

When the AI community says a model "reasons," it is making a claim about _method_. But we evaluate that claim by looking at _outputs_ --- accuracy on benchmarks.

**We are conflating method with result.** The same conflation Landry diagnoses across the entire history of mathematical philosophy.

A model gets 90% on a math benchmark by pattern-matching to training data. It generates chain-of-thought that _looks_ like reasoning but may function largely as post-hoc rationalization --- the exact nature of these internal processes is still debated, but TF-Bench's results suggest the structural component is thin. It solves code tasks by recognizing variable names without understanding type-theoretic structure.

Whatever is happening inside these models, it is not reasoning in the formal sense. Reasoning requires three things:

1. **Axioms** --- clearly stated starting assumptions.
2. **Derivation rules** --- well-defined rules of inference.
3. **Deduction** --- arriving at conclusions through valid steps from those axioms.

Current benchmarks do not test this. NL inference benchmarks have no formal oracle. Symbolic logic benchmarks are out-of-distribution. Math word problems can be memorized. Even task perturbation methods for math benchmarks face a fundamental problem: natural language makes it impossible to systematically determine which tokens can be substituted without altering semantics.

Type inference sidesteps all of this. The oracle is well-defined --- does the inferred type compile? Perturbations are semantics-preserving --- alpha-renaming is a standard, verified transformation. And the task is in-distribution for models trained on code.

Call it **the name test**: strip away the natural language cues and see what survives.

## The Experiment

We ran the name test. We built type inference tasks from Haskell's standard Prelude, then created **TF-Bench$_{\text{pure}}$**: every function name becomes `f1`, `f2`, `f3`. Every type name becomes `T1`, `T2`. The logical structure is preserved exactly. The cognitive semantics are gone.

If the model is reasoning, performance should survive.

It collapses. Across 64 models, the pattern is consistent. Strip the names, and the "reasoning" largely disappears. The [paper](https://yfhe.net/publications/he2025tfbench.pdf) has the full results and metrics.

One finding worth highlighting here: **math fine-tuning transfers. Code fine-tuning sometimes does not.** This makes sense through the Curry-Howard lens --- mathematical reasoning and type-theoretic reasoning are structurally the same activity. Train on one, and it transfers. But code training sometimes just teaches better pattern matching on names.

## What This Means

The field is making what Landry would call the original sin: **confusing the appearance of reasoning with its substance.** Chain-of-thought _looks like_ human reasoning. We take that as evidence it _is_ reasoning. But strip the surface, test the structure, and the performance tells a different story.

LLMs are extraordinarily useful. They might one day genuinely reason. But right now, we are not even measuring the right thing.

The philosophical tradition is clear. Reasoning operates on **structure**, not **names**. Category theory defines objects by their morphisms, not their labels. Type theory, via Curry-Howard-Lambek, says the same thing in code: a type is its structural role in the system, not what it is called.

A model that infers the type of `map` but fails on `f3` does not understand type inference. It recognizes `map`.

Landry's as-ifism gives us the test. The model should take the provided axioms _as if_ they were first principles and deduce the conclusion from logical structure alone. Names are cognitive scaffolding for human readers. They are not logical content. **The model should reason about the morphism, not the label on the object.**

Three things need to happen:

1. **Evaluation grounded in formal systems.** Benchmarks where the oracle is well-defined, derivation rules are explicit, and correctness is mechanically verified.

2. **The name test as standard practice.** Any serious reasoning evaluation must include variants that strip NL cues. If performance collapses, the model is not reasoning.

3. **Metrics that measure reasoning, not accuracy.** RS and RE are initial proposals. The field needs more tools to understand _how_ models arrive at answers, not just whether they do.

The bridge from category theory to type theory to LLM evaluation is not an accident. It is the same insight applied at every level: **reasoning is about structure, and any serious test of reasoning must test structure, not surface.**

We are not there yet. But now we know what "there" looks like.

## References

**TF-Bench paper**: Y. He, L. Yang, C. Castro Gaw Gonzalo, H. Chen. "Evaluating Program Semantics Reasoning with Type Inference in System F." _NeurIPS 2025 Datasets and Benchmarks Track_. [[PDF]](https://yfhe.net/publications/he2025tfbench.pdf) [[GitHub]](https://github.com/SecurityLab-UCD/TF-Bench) [[OpenReview]](https://openreview.net/forum?id=IA9RmaP0aw)

**Professor Landry's work**:

- E. Landry. [_Plato Was Not a Mathematical Platonist_](https://doi.org/10.1017/9781009313797). Cambridge Elements in the Philosophy of Mathematics, 2023.
- E. Landry. "How to be a Structuralist All The Way Down." _Synthese_ 179, 2011.
- E. Landry. "Recollection and the Mathematician's Method in Plato's Meno." _Philosophia Mathematica_ 20(2), 2012.
- E. Landry and J.-P. Marquis. "Categories in context: Historical, foundational and philosophical." _Philosophia Mathematica_ 13(1), 2005.

**The Curry-Howard-Lambek correspondence**:

- H. Curry. "Functionality in Combinatory Logic." _Proceedings of the National Academy of Sciences_ 20(11), 1934.
- W. Howard. "The Formulae-as-Types Notion of Construction." _To H.B. Curry: Essays on Combinatory Logic, Lambda Calculus, and Formalism_, 1980.
- P. Wadler. "Propositions as Types." _Communications of the ACM_ 58(12), 2015.
