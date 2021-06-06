---
title: Constants
date: 2021-06-06 17:20:15
tags:
  - Note
  - math
  - algebra
  - calculus
category: Science
---

# What should we add a constant after getting the Antiderivative of first order functions?

Few days ago, I saw this question under [@Phenomene Bizarre](https://www.zhihu.com/people/likeyong)'s 
post [如何正确理解群论中的同态基本定理？](https://www.zhihu.com/question/54508642/answer/154155831).
I thought this different approach to explain a simple question is really interesting.
So here comes this blog.

## Background

First we should clarify the question a little bit.
As asked, when we try to find the antiderivative of a first order function $f$ with respect to variable $x$,
$$
\int f \ dx = F + c.
$$
why should we always add the constant $c$ at the end?

## Definitions

**Definition**. $C^1(\mathbb{R})$ is the set of first order continuously differentiable functions on $\mathbb{R}$.

## An Algebraic Approach

To talk about antiderivative, we should first understand the definition of **derivative**.
As defined, derivative of a function in this case is epimorphism mapping from $C^1(\mathbb{R})$ to $C^0(\mathbb{R})$,
$$
D := \frac{d}{dx} : C^1(\mathbb{R}) \rightarrow C^0(\mathbb{R}).
$$

That is, if a function $f$ nis integrable, then it must be in the image of the above function,
$$
f \text{ is integrable} \iff f \in \mathrm{im} D.
$$

Since $D$ is an epimorphism, by the First Isomorphism Theorem,
there exists an unique isomorphism 
$$
\phi : C^1(\mathbb{R}) \big/ \ker D \rightarrow \mathrm{im}D
$$
where $C^1(\mathbb{R}) \big/ \ker D$ is the quotient space of $C^1(\mathbb{R})$.

Since isomorphism is bijective, there exists an inverse function of $\phi$
$$
\phi^{-1} : \mathrm{im}D \rightarrow C^1(\mathbb{R}) \big/ \ker D
$$
that maps form the image of function $D$ to the quotient space,
which as we know is the **antiderivative function**.
Then it is clear that the antiderivative of $f$, $F \in C^1(\mathbb{R}) \big/ \ker D$.

Since $\ker D$ is a normal subgroup to $C^1(\mathbb{R})$,
by [definition of quotient group](https://en.wikipedia.org/wiki/Quotient_group),
$C^1(\mathbb{R}) \big/ \ker D$ is the set of all [left cosets](https://en.wikipedia.org/wiki/Coset)
of $\ker D$ in $C^1(\mathbb{R})$.
That is,
$$
C^1(\mathbb{R}) \big/ \ker D = \\{ a + \ker D: a \in C^1(\mathbb{R}) \\}.
$$

{% note secondary %}
Here we say it is $a + N$ because $+$ is the binary operation defined on $C^1(\mathbb{R})$.
{% endnote %}

Then what is the kernel of function $D$?
By [definition](https://en.wikipedia.org/wiki/Kernel_(algebra)),
the kernel of a morphism is the set of all elements from the domain mapped to the identity element in image.
In this case, since the identity of $+$ on $\mathbb{R}$ is $0$,
$$
\ker D = \\{a : a \in C^1(\mathbb{R}) \land a \mapsto 0 \\} \subseteq \mathbb{Z}.
$$

Therefore, we should add the constant when finding antiderivative or indefinite integral.
