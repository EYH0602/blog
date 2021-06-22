---
title: Isomorphic of Composition
date: 2021-06-22 18:10:36
tags:
  - Note
  - math
  - algebra
category: Science
---

# Isomorphic of Composition

Are the composition of isomorphism still isomorphic?

Symmetric is one of the most ideal appearance of all structure, including mathematics.
In math, isomorphism provides the symmetry between different mathematical structures.

Therefore, if the composition between isomorphism can keep to be isomorphic,
we can compose morphism in arbitrary way while keeping the structure!

As defined in general algebra, if two structures $A$ and $B$ isomorphic,
there exists a function/mapping 
$$
\varphi : A \rightarrow B
$$
which is bijective and keeps the structure from $A$ to $B$.

As for category theory, let $\mathcal{C}_1$ and $\mathcal{C}_2$ be functors where

$$
F : \mathcal{C}_1 \rightarrow \mathcal{C}_2, \ 
G : \mathcal{C}_2 \rightarrow \mathcal{C}_1
$$

satisfies that

$$
FG = \mathrm{id}_{\mathcal{C}_{2}, \ 
GF = \mathrm{id}_{\mathcal{C}_{1}
$$

we say that $F$ is a isomorphism between categories, and $G$ is its inverse.

We will solve the problem in two steps.

## If composition of functions is isomorphic, so are this functions.

Let
$$
A \xrightarrow{f} B \xrightarrow{g} C \xrightarrow{h} D
$$
be arbitrary morphisms between categories.
If $A \xrightarrow{gf} C$ and $B \xrightarrow{hg} D$ are isomorphic,
then $f$, $g$, and $h$ are all isomorphic.

*Proof*.
Assume, for contraction, that
$A \xrightarrow{gf} C$ and $B \xrightarrow{hg} D$ are isomorphisms but $g$ is not.
Then either $gg^{-1} \neq {id}_{C}$ or $g^{-1}g \neq \mathrm{id}_{B}$

1. If $gg^{-1} \neq \mathrm{id}_{C}$, then $f^{-1}g^{-1}gf \neq \mathrm{id}_{A}$.
2. If $g^{-1}g \neq \mathrm{id}_{B}$, note the commutative property of natural transformation, $g^{-1}h^{-1}hg \neq \mathrm{id}_{B}$.

The step to show if $f$ or $h$ are not isomorphic then there is a contradiction
based on the commutative property of functors is similar.

Thus, we reach a contraction.
Therefore if $A \xrightarrow{gf} C$ and $B \xrightarrow{hg} D$ are isomorphic,
then $f$, $g$, and $h$ are all isomorphic.

