---
title: "Reasoning Is Not What You Think It Is"
date: 2025-02-24 12:00:00
tags:
  - research
  - philosophy
  - math
  - LLM
  - type theory
category: Research
---

# Reasoning Is Not What You Think It Is

The AI community has a reasoning problem. Not a technical one --- a conceptual one.

In the past two years, we have witnessed a remarkable shift: large language models that can "think" step by step, plan before answering, and produce chains of inference that look strikingly human. OpenAI's o1, DeepSeek-R1, Claude with extended thinking --- test-time compute (TTC) has become the new scaling paradigm, and the excitement is palpable. People are calling it a step toward AGI. The models can reason.

But can they? I think the field is conflating two fundamentally different things, and I want to explain why.

This is the thinking behind [TF-Bench](https://yfhe.net/publications/he2025tfbench.pdf), our benchmark published at the [NeurIPS 2025 Datasets and Benchmarks Track](https://openreview.net/forum?id=IA9RmaP0aw). The paper describes the technical contribution. This post describes how I got there --- the intellectual path, the ideas I borrowed from a completely different field, and my take on what "intelligence" actually requires.

## Two Kinds of Semantics

Here is the core distinction. When a programmer reads code, they rely on two very different kinds of information:

1. **Program semantics**: the formal, structural logic of the program --- types, data flow, function composition. This is what the compiler sees. Renaming every variable to `x1`, `x2`, `x3` does not change it.

2. **Cognitive semantics**: the natural language layer --- meaningful variable names, comments, naming conventions. This is what helps *humans* understand code. It has zero effect on how the program executes.

A function named `filterEvenNumbers` and one named `f7` can be structurally identical. The compiler does not care. But an LLM, I suspected, cares a great deal.

This gap --- between what the program *means* formally and what it *suggests* linguistically --- is, I believe, the key to understanding what current LLMs are actually doing when we claim they "reason." They are operating much more in the cognitive semantics space than the program semantics space. They understand code the way a reader does, not the way a compiler does.

This is not a new observation. But I think the implications go deeper than people realize, and the framing I use to think about it comes from an unlikely source.

## The Foundational Crisis and What It Teaches Us

The history of mathematics in the 19th and 20th centuries is, in large part, a story of foundations collapsing.

Set theory, proposed as the bedrock of all mathematics, met Russell's paradox: the set of all sets that do not contain themselves both must and must not contain itself. Hilbert's program --- the ambitious attempt to prove mathematics consistent and complete from within --- was shattered by Gödel's incompleteness theorems. Each proposed foundation cracked under its own weight.

This sounds like an intellectual dead end. It is actually one of the most important stories in the history of human thought, because it forces you to confront: *if the foundations are not settled, what are mathematicians actually doing when they do mathematics?*

I was inspired by [Professor Elaine Landry](https://philosophy.ucdavis.edu/people/elaine-landry)'s work on this question. Her answer is what she calls **as-ifism** --- methodological as-if realism. The idea is deceptively simple:

> In mathematics, we treat our hypotheses *as if* they were true first principles, and consequently, our objects *as if* they existed, and we do this for the purpose of solving problems.

The mathematician does not need to commit to whether numbers "really exist" in some metaphysical realm. She takes her axioms *as if* they were true, and reasons downward from them to a conclusion. The method is the *hypothetical method*: start from assumptions, apply derivation rules, arrive at results. Truth comes first; existence follows as a consequence.

This is distinct from Platonism (mathematical objects exist independently and truth is fixed by that existence), from formalism (mathematics is just symbol manipulation), and from standard structuralism (which gets tangled in metaphysical debates about whether structures exist *ante rem* or *in re*). Landry's position is **methodological**: it describes what we *do*, not what things *are*. As she puts it: "mathematics is a language; it talks about objects without being about them."

She traces this reading back to Plato himself, arguing in her Cambridge Elements book [*Plato Was Not a Mathematical Platonist*](https://doi.org/10.1017/9781009313797) that the standard story about Plato is wrong. Plato's mathematician uses the hypothetical method; the philosopher uses the dialectical method. These are different methods with different epistemologies. Confusing them is, Landry argues, the original sin of 2,400 years of philosophy of mathematics --- a conflation of metaphysics with method that persists today.

## Category Theory as a Methodological Metalanguage

Here is where this becomes directly relevant to evaluating AI.

After the foundational crisis, mathematicians needed a way to organize mathematical discourse without falling into the same traps. Category theory emerged as a candidate --- but not, on Landry's account, as yet another metaphysical foundation. Instead, she views category theory as a **methodological metalanguage**: a framework for talking about structured systems (sets, groups, topological spaces, deductive systems) without committing to what those systems ultimately *are*.

The category axioms --- whether EM axioms for sets, ETCS axioms for set-structured categories, or CCAF axioms for categories themselves --- are taken *as if* they were first principles. They are hypotheses set up for the purpose of solving mathematical problems. We act as if category theory were a foundation for mathematical structuralism, while recognizing that, metaphysically speaking, it is not. What matters is the *method*: reasoning from structure alone.

This insight --- that mathematical reasoning operates on **structure**, not on **names** or metaphysical commitments --- is the key to everything that follows.

A group theorist who proves a theorem about group $G$ does not need to know what $G$ "really is." She needs only its axioms and the derivation rules. If her proof breaks when you rename $G$ to $H$, she does not understand group theory. She recognizes $G$.

## From Categories to Types

Category theory and type theory turn out to be two faces of the same coin.

The Curry-Howard-Lambek correspondence --- extending the classical Curry-Howard isomorphism with Lambek's categorical semantics --- establishes a three-way equivalence:

| **Logic** | **Type Theory** | **Category Theory** |
|---|---|---|
| Propositions | Types | Objects |
| Proofs | Programs | Morphisms |
| Implication ($A \Rightarrow B$) | Function type ($A \to B$) | Exponential object |
| Conjunction ($A \wedge B$) | Product type ($A \times B$) | Categorical product |

A function of type $A \rightarrow B$ is simultaneously a proof that $A$ implies $B$ *and* a morphism from object $A$ to object $B$ in a category. The function's implementation *is* the proof; its type signature *is* the proposition.

This is not metaphor. It is a mathematical correspondence, and it is the foundation on which Haskell's type system (based on System F, the polymorphic lambda calculus) is built.

The connection to Landry's program is direct. Category theory provides the structural framework in which types, propositions, and proofs are unified as the same mathematical objects viewed from different angles. If reasoning is about operating on structure --- as the as-ifist tradition insists --- then type theory gives us a formal system where that structural reasoning can be tested precisely.

Now consider what this means for evaluating LLMs:

- **Type dependencies** (the type signatures of invoked functions) are **logical assumptions** --- or equivalently, the axioms we take *as if* they were first principles.
- **Function implementation** is a **proof structure** --- or equivalently, a morphism in the relevant category.
- **Type inference** --- inferring the type signature from the implementation --- is **natural deduction** from those axioms.

And here is the crucial advantage: code is abundant in LLM training data. Models have seen enormous amounts of Haskell, Python, Java. They are "in-distribution" for code in a way they are not for symbolic logic notation. So type inference gives us a way to test *formal deductive reasoning* within a domain the models can actually engage with.

This is the idea behind [TF-Bench](https://github.com/SecurityLab-UCD/TF-Bench).

## Why This Matters for AI

When the AI community says a model "reasons," it is making a claim about the model's *method*. But we evaluate that claim by looking at the model's *outputs* --- accuracy on benchmarks. We are conflating method with result, just as Landry argues the history of philosophy of mathematics conflates method with metaphysics.

A model can achieve 90% on a math benchmark by pattern-matching to similar problems in its training data. It can generate convincing chain-of-thought explanations that are post-hoc rationalizations rather than the actual causal path to its answer. It can solve code tasks by recognizing variable names and function signatures without understanding the underlying type-theoretic structure.

None of this is reasoning in the sense that matters. Reasoning, in any tradition worth taking seriously, requires:

1. **Axioms**: clearly stated starting assumptions.
2. **Derivation rules**: well-defined rules of inference.
3. **Deduction**: arriving at conclusions through logically valid steps from those axioms, using those rules.

Current benchmarks do not test this. Natural language inference benchmarks have no formal oracle. Symbolic logic benchmarks use notation that is out-of-distribution for models trained on internet text. Math word problems can be solved by memorization. Even task perturbation methods designed for math benchmarks face a fundamental problem: because math QA tasks are constructed in natural language, it is difficult to systematically determine which tokens can be substituted without altering the problem's semantics. This makes it hard to verify that perturbations are sound.

Type inference sidesteps all of these problems. Through the Curry-Howard correspondence, type inference tasks align with natural deduction. The oracle is well-defined (does the inferred type compile?). Perturbations are semantics-preserving (alpha-renaming is a standard, verified transformation). And the task is in-distribution for models trained on code.

## The Experiment and What It Shows

We built 188 type inference tasks from Haskell's standard Prelude --- monomorphic, parametric polymorphic, and bounded quantification functions. Haskell's type system is sound, making it a natural choice. Each task provides the function implementation and all type dependencies. The model must infer the complete type signature.

Then we did something that, as far as I know, no prior benchmark had done: we created **TF-Bench$_{\text{pure}}$**, a variant where *all natural language is removed*. Function names become `f1`, `f2`, `f3`. Type names become `T1`, `T2`. Type variables are standardized. The logical structure is preserved exactly. The cognitive semantics are stripped away. Every transformation is verified to be semantics-preserving through compilation.

If reasoning is real, performance should be roughly preserved. If the model is relying on natural language cues, performance collapses.

It collapses.

The best model (Claude-3.7-sonnet) goes from 90.42% on TF-Bench to **55.85%** on TF-Bench$_{\text{pure}}$. Nearly 35 points gone. GPT-O3, OpenAI's flagship reasoning model, drops from 81.91% to 52.66%. Across 64 models, the pattern is consistent: strip away the names, and the "reasoning" largely disappears.

We formalized this with two metrics:

**Robustness Score (RS)** = Acc$_{\text{pure}}$ / Acc. How much of the model's performance survives when cognitive semantics are removed. A perfect reasoner has RS = 100.

**Reasoning Effectiveness (RE)** = $\Delta_{\text{pure}}$ / $\Delta$. When you turn on test-time reasoning, how much of the improvement comes from better deductive reasoning (improvement on TF-Bench$_{\text{pure}}$) versus better exploitation of NL cues (improvement on TF-Bench)? RE > 1 means TTC genuinely improves reasoning. RE < 1 means it mostly helps with memorization and NL pattern matching.

The RE results are telling. Gemini-2.5-flash achieves RE = 3.90 and Claude-3.7-sonnet achieves RE = 3.41 --- their TTC methods do seem to improve genuine reasoning. But some models fine-tuned on code show RE < 1, meaning the fine-tuning *hurt* deductive reasoning while improving surface-level performance.

One of the most interesting findings: models fine-tuned on **math** data consistently improve on both TF-Bench and TF-Bench$_{\text{pure}}$, while models fine-tuned on **code** sometimes improve on TF-Bench but *decline* on TF-Bench$_{\text{pure}}$. Math training seems to build transferable abstract reasoning; code training sometimes just teaches better pattern matching on natural language cues in code. This aligns with the Curry-Howard correspondence --- mathematical reasoning and type-theoretic reasoning are structurally the same activity, so training on one transfers to the other.

## What I Actually Think About Intelligence

Let me state my position clearly.

I think the field is making an error analogous to what Landry identifies in the history of philosophy of mathematics: **confusing the appearance of reasoning with its substance**. The cognitive semantics of chain-of-thought outputs --- the fact that they *look like* human reasoning --- is being taken as evidence that the underlying process *is* reasoning. But when you strip away the surface and test the structural logic directly, the performance tells a different story.

This does not mean LLMs are not useful. They are extraordinarily useful. It does not mean they will never reason. They might. But I think we need to be much more precise about what we mean by "reasoning," and much more rigorous about how we test for it.

The philosophical tradition behind this work says that reasoning requires operating on **structure**, not on **names**. Category theory teaches us that mathematical objects are defined by their relationships --- their morphisms --- not by what they are "made of." Type theory, via Curry-Howard-Lambek, gives us the same lesson in a programming context: a type is defined by its structural role in the system, not by what it is called. A model that can infer the type of `map` but fails when you call it `f3` does not understand type inference. It recognizes `map`.

Landry's as-ifism provides the precise lens. The model should be able to take the provided axioms (type dependencies) *as if* they were true first principles and deduce the conclusion (the type signature) purely from the logical structure. The names are irrelevant. They are cognitive scaffolding for human readers, not logical content. In the language of category theory: the model should reason about the morphism, not the label on the object.

We are not there yet. But I believe the path forward requires:

1. **Evaluation grounded in formal systems** --- benchmarks where the oracle is well-defined, the derivation rules are explicit, and correctness can be mechanically verified. TF-Bench is one step in this direction.

2. **Separation of cognitive and program semantics** --- any serious reasoning evaluation must include variants that strip away NL cues, so we can distinguish genuine reasoning from memorization and pattern matching.

3. **Metrics that measure reasoning, not just accuracy** --- our RS and RE metrics are initial proposals. The field needs more tools like these to understand *how* models arrive at answers, not just whether they do.

The gap between cognitive semantics and program semantics is, I think, the central challenge for the next phase of AI reasoning research. Closing it will require not just better training methods, but better ways of thinking about what reasoning means in the first place.

The bridge from category theory to type theory to LLM evaluation is not an accident. It is the same insight, applied at different levels: reasoning is about structure, and any serious test of reasoning must test structure, not surface.

## References

**TF-Bench paper**: Y. He, L. Yang, C. Castro Gaw Gonzalo, H. Chen. "Evaluating Program Semantics Reasoning with Type Inference in System F." *NeurIPS 2025 Datasets and Benchmarks Track*. [[PDF]](https://yfhe.net/publications/he2025tfbench.pdf) [[GitHub]](https://github.com/SecurityLab-UCD/TF-Bench) [[OpenReview]](https://openreview.net/forum?id=IA9RmaP0aw)

**Professor Landry's work**:
- E. Landry. [*Plato Was Not a Mathematical Platonist*](https://doi.org/10.1017/9781009313797). Cambridge Elements in the Philosophy of Mathematics, 2023.
- E. Landry. "Recollection and the Mathematician's Method in Plato's Meno." *Philosophia Mathematica* 20(2), 2012.
- E. Landry and J.-P. Marquis. "Categories in context: Historical, foundational and philosophical." *Philosophia Mathematica* 13(1), 2005.

**The Curry-Howard-Lambek correspondence**:
- H. Curry. "Functionality in Combinatory Logic." *Proceedings of the National Academy of Sciences* 20(11), 1934.
- W. Howard. "The Formulae-as-Types Notion of Construction." *To H.B. Curry: Essays on Combinatory Logic, Lambda Calculus, and Formalism*, 1980.
- P. Wadler. "Propositions as Types." *Communications of the ACM* 58(12), 2015.

**Background**: [Elaine Landry, UC Davis Department of Philosophy](https://philosophy.ucdavis.edu/people/elaine-landry)
