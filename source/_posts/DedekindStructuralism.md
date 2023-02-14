---
title: Dedekind's Structuralist View of Natural Numbers
date: 2023-02-14 15:01:13
tags:
  - philosophy
  - math
category: Philosophy
---

# Connect Dedekind's structuralist view of natural numbers to the Hilbert and Bernays quotes

> Hilbert: We think of ... points, straight lines, and plans as having certain mutual relations, which
> we indicate by means of such works as "are situated", "between", "parallel", "congruent",
> "continuous", etc. The complete and exact description of these relations flows as a consequence
> of the axioms of geometry.
>
> Bernays: A main feature of Hilbert's axiomatization of geometry is that the axiomatic
> method is presented and practiced in the spirit of the abstract conception of axiomatics
> that arose at the end of the nineteenth century and which has been generally adopted in
> modern mathematics. It consists in abstracting from the intuitive meaning of the terms for
> the kinds of primitive objects (individuals) and for the fundamental relations and in
> understanding the assertions (theorems) of the axiomatized theory in a hypothetical sense,
> that is, as holding true for any interpretation or determination of the kinds of individuals
> and of the fundamental relations for which the axioms are satisfied. Thus, an axiom
> system is regarded not as a system of statements about a subject matter but as a system of
> conditions for what might be called a relational structure.
> -> a theory gives a relational structure

## Dedekind's view

Dedekind's structuralist view of natural numbers is a theory that
natural numbers should be defined as a system in terms of their properties and relationships
as said out in the Peano axioms $P^2A$.
In fact, for Dedekind, such a system is not limited to $\{1, 2, 3, \ldots\}$,
it is whatever satisfies axioms, for example

- $\{0, 1, 2, \ldots\}$,
- $\{ \emptyset, \{\emptyset\}, \{\{\emptyset\}\}, \ldots \}$,
- $\{\lambda f. \lambda x.x, \lambda f. \lambda x.fx, \lambda f. \lambda x.f(fx), \ldots\}$,

or any $\omega$-sequence satisfies the axioms are natural numbers.
I will describe the similarities between Dedekind's structuralist view of natural numbers to the Hilbert and Bernays quotes,
then conclude with some difference between Hilbert's view and Dedekind's view.

## Variable Domain

For Hilbert, from his quote listed, geometry objects
like points, lines, and planes are defined by the relations between them,
such as "are situated", "between", "parallel", "congruent", "continuous", etc.
These are all relations set by the axioms.
In other words, we implicitly defines the objects in virtual of relations that are given by axioms.
This view gives the notion of \*variable domain".
That is, points, lines, planes can be anything,
even chairs, tables, coffee mugs,
as long as they satisfies the relations given the axioms.
In comparison to Dedekind's view of natural numbers,
Dedekind believed that any system satisfies $P^2A$ is a system of natural numbers.
There two views from Hilbert and Dedekind ares just as described in Bernays quote
"an axiom system is regarded not as a system of statements about a subject matter
but as a system of conditions for what might be called a relational structure."

In conclusion to Hilbert's view of geometry and Dedekind's view of natural numbers
is that whether the axioms is _categorical_.
That is, all the systems that satisfies the axioms are equivalent up to isomorphism.
Although similar, there is still a different between these two views.
Hilbert believed that axioms define _structure_,
whereas Dedekind believed that axioms define _systems that have a structure_.
Other than this difference,
the same central idea is that an object is defined solely un terms of its relations,
which is (sort of) prove by the Yoneda Lemma.
