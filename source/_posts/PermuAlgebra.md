---
title: "Permutation Algebra"
date: 2020-12-20
tags:
  - Note
  - math
  - algebra
  - Python
  - programming
category: "Science 👨‍💻"
---

# Permualgebra

## Install

```shell
pip3 install permualgebra
```

## Permutation

Let $S$ be a set of n distinct elements. 
A **permutation** of $S$ is a *bijection*

$$
p : S \rightarrow S.
$$

For example, let $S = \{ 1,2,3,4,5,6 \}$, define

| $i$    | 1    | 2    | 3    | 4    | 5    | 6    |
| ------ | ---- | ---- | ---- | ---- | ---- | ---- |
| $p(i)$ | 6    | 3    | 2    | 4    | 5    | 1    |

Or a permutation can be written in **cycle notation**, where we often *omit* the 1-cycles:

$$
p = \text{(1 6)(2 3)(4)(5)} = \text{(1 6)(2 3)}
$$

this cycle notation is also the way that this package express a permutation.

* The **length of a cycle** is the number of elements of  in that cycle.
* The **length of a permutation** is the number of cycles in that permutation.

## Theorem

**Every permutation** on $S = [1..n]$ can be written as a product of disjoint cycles.
i.e. no elements of $S$ is repeated in the cycle description.

```python
import permualgebra as pm
p = pm.Permutation(["3 6 4 2", "1 3 4 6", "5 2 1 3"])
print(p)            # (3 6 4 2)(1 3 4 6)(5 2 1 3)
pSimplify = p.getSimplify()
print(pSimplify)    # (1 2 6)(3 5)
p.simplify()
print(p)            # (1 2 6)(3 5)
```

Suppose we have 2 permutations $p : S \rightarrow S$ and $q : S \rightarrow S$,
we can compose them as

$$
p \circ q : S \rightarrow S. 
$$

we often write $p \circ q$ as $pq$.

**Note.**
composition of permutations is not commutative.

Let $p = \text{(1 5)(2 4 6)}$, $q = \text{(1 3 5 4)(2 6)}$, then we have

$$
    pq 
    = \text{(1 5)(2 4 6)(1 3 5 4)(2 6)}
    = \text{(1 3)(2)(4 5 6)}
    = \text{(1 3)(4 5 6)}
$$

and

$$
\begin{align*}
    qp
    = \text{(1 3 5 4)(2 6)(1 5)(2 4 6)}
    = \text{(1 4 2)(3 5)}
    \neq pq.
\end{align*}
$$

This package implements the composition of permutation as *multiplication*. 

```python
import permualgebra as pm

p = pm.Permutation(["1 5", "2 4 6"])
q = pm.Permutation(["1 3 5 4", "2 6"])
p.simplify()
q.simplify()
print((p*q).getSimplify())  # (1 3)(4 5 6)
print((q*p).getSimplify())  # (1 4 2)(3 5)
```

