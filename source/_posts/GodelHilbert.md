---
title: Hilbert's Program and Godel's Inconsistency Theorem
date: 2023-02-09 17:10:39
tags:
  - philosophy
  - math
category: Philosophy
---

# What are Godel's Theorem and how did they collapse Hilbert's program?

Hilbert's program is a way to show that an axioms system is both consistent and complete.
Godel's incompleteness theorems has two parts:
1. no consistent system of axioms whose theorem are effective that can prove all the truth of arithmetic;
2. any such system cannot prove its own consistency.
The second theorem proves that Hilbert's program was not achievable and mathematics is inherently incomplete.
After demonstrating the idea of Hilbert's program and how Godel's Theorem undermines it,
I will conclude with some way to circumvent the limitation of Godel's Theorem.

## Hilbert's Program

Hilbert, who sometimes be interpreted as a formalist,
aimed to show that geometry is founded by its axioms.
To achieve this, we need show that the axiom system is both consistent and complete by proof in logic.
This goal of proving is known as Hilbert's program.
To Hilbert, axioms are not truth but scheme for talking about axioms.
For him, consistency implies existence and truth.
% notion of consistency
Hilbert first shows that geometry is consistent
since it can be interpreted by real numbers.
In other words, geometry is consistency in relative to analysis.
Therefore, the axioms of geometry is satisfied by the theory of analysis.
The way of using another system to proof the consistency of a system 
is called a *relative consistency proof*.
However, we then need to show the consistency of analysis.
The question becomes to deduce the whole mathematics to a finite set of axioms which is consistent and complete,
then use this set of axioms to give a *absolute consistency proof*.
The Second Incompleteness Theorem states that such a axioms system does not exist,
which completely undermines the Hilbert's program.

## proof cannot capture truth

Although Godel's Incompleteness Theorem shows that none axiom system can shows its own consistency,
it only deny the existence of *absolute consistency proof* but not *relative consistency proof*.
Upon assuming the correctness of a axioms system,
we can still deduce further theorem based on the assumptions.
For example, upon the Peano Axioms we can build the theory of real analysis.
This idea is akin to As-ifism where
we take hypothesis <u>as if</u> they were true.
