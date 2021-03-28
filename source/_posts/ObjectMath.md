---
title: Object Oriented Mathematics !?
date: 2021-03-26 09:47:03
tags:
  - Note
  - math
  - algebra
  - Haskell
  - functional
  - programming
  - logic
  - HackerHub
category: Science

---

# Mathematical Structure

{% note success %}
This post is a quick introduction to basic Modern Algebra and Category Theory.
I think these concepts will help the understanding of 
`fold` function, Monoid, and Monad.
If you are not interested or feel not necessary,
feel free to skip this post.
`fold` function, Monoid, and Monad can be understood without these math background.
{% endnote %}

We often heard the concept of "Data Structure",
which is how data is store and loaded in the memory.
Data Structures are something actually exists in the memory,
but math is the abstract language people created to describe the world.

How does math have structure?

{% note secondary %}
Come to think about this,
isn't Math a functional language?
{% endnote %}

Recall that we mentioned the structure of set in post [Think about Functions](/2021/03/19/Function/index.html).
We said a set can have some structure: open, closed, compact, connected ...
and continuous functions preserves the structure of a set.

Other than this,
what are the more general mathematical structures?

## Group

**Definition:**
A set $G$ with a *binary operation* $*$ defined on it is called a **group** if
* the binary operation is associative,
* the binary operation has a identity element in the set,
* the binary operation provides an inverse for every element of $G$.

This group can be denoted $(G, *)$.

We can describe the definition in mathematical language.
This is, $(G, *)$ is a group if
* $\forall a,b,c \in G$, $(a * b) * c = a * (b * c)$.
* $\exists \mathbb{1} \in G$ such that $\forall a \in G$, $\mathbb{1} * a = a * \mathbb{1} = a$.
* $\forall a \in G$, $\exists a^{-1} \in G$ such that $a * a^{-1} = a^{-1} * a = \mathbb{1}$.

Let's look at some examples.

$(\mathbb{R}, +)$ is a group.
* associativity is trivial.
* Since forall $a \in \mathbb{R}$, $a + 0 = 0 + a = a$, the identity is $0$.
* For all $a \in \mathbb{R}$, there exists $-a \in \mathbb{R}$ such that $a + (-a) = (-a) + a = 0$.

**Definition:** General Linear Group $GL_n(\mathbb{R})$ 
is set of matrix in matrix space $\mathbb{R}^n$ whose determinate is not 0.
$$ GL_n(\mathbb{R}) = \\{ A \in \mathcal{M}_n(\mathbb{R}) | \det A \neq 0 \\}. $$
And the binary operation for linear groups are *matrix multiplication*.

As it is called, $GL_2(\mathbb{R})$ is a group under matrix multiplication since
* matrix multiplication is associative 
* identity is the "identity matrix" $ \begin{bmatrix} 1 & 0 \\\\ 0 & 1 \end{bmatrix} $.
* Let $A = \begin{bmatrix} a & b \\\\ c & d \end{bmatrix} \in GL_2(\mathbb{R})$,
    then its identity is
    $$ A^{-1} = \frac{1}{ad - bc} \begin{bmatrix} -a & c \\\\ b & -d \end{bmatrix}. $$
    $A^{-1} \in GL_2(\mathbb{R})$ because $$ \det A^{-1} = \frac{1}{\det A} \neq 0. $$

{% note secondary %}
Recall in the post on functions, we said $n \times n$ matrix are functions.
This this is a group of functions!
{% endnote %}

In post [Think about Functions](/2021/03/19/Function/index.html),
we introduced functions acting on a pentagon.
That is,
* $x$ rotate the polygon by $2\pi/n$ around its center.
* $y$ rotate the polygon by $\pi$ about vertical.

And we get the following set of actions
$$ A_5 =  \\{ \mathbb{1}, x, x^2, x^3, x^4, y, xy, x^2y, x^3y, x^4y \\} $$
which is a group defined under function composition.

In fact, this group is called the **alternating group** order 5.
The same action $x$ and $y$ can be performed on any $n$-side right polygon,
and get an alternating group of order $n$.

Why is this mathematical structure, group, important?
The reasons are *closure* and *symmetry*.
With these two properties,
we can compose functions freely.

**Theorem.**
Let $(G, \*)$ be group,
then set $G$ is closed under the binary operation $*$.
That is, $\forall a, b \in G$, $a * b = c \in G$.

{% note secondary %}
You can try to prove this property for the examples we give in the beginning.
{% endnote %}

With closure, we have the freedom to compose functions in the same group.
And the result function of compose will always be in the same group.
This lead us to another hot topic of modern computer science: **Domain Specific Programming**.

Think about this,
we have some different parts of a project,
* some of them are for backend, written in Haskell, F#, Rust, or others ...
* Database and SQL scripts,
* frontend programs written in JS, TS ...

The functions are written in different languages,
serving as different parts,
but if all of them follows the same standard (domain),
we can compose these functions!
How wonderful is that.

## Monoid

Making a set of functions that forms a group under function composition seems like a bright future,
but there is some issue of that.
Unlike mathematics,
it's really hard to find the inverse for functions in programs.
Therefore, we want to leave that part out in our definition of mathematical structure.

**Definition:**
A **monoid** is a set and a function/mapping defined on that such that
* the function is associative on that set,
* the function has an identity element.

That is,
a monoid is just a group that may or may not have inverse for all elements.

In this way,
it is easily for our functions (as programs) to form a monoid.

**Theorem.**
If a set $M$ is a monoid under binary operation $*$,
then $M$ is closed under $*$.

{% note secondary %}
Monoid also have the closure property.
Guess which two requirements of group provides closure?
{% endnote %}

## Category

If you are a math major,
you have probably notice that there are similar structures in different of math.

For example, group and metric spaces are very similar in that way that
both of them are a set (sequence) of some objects and a function defined on them.

Since math is all about abstraction,
we want to a structure to represent all structures of the same pattern.

{% note secondary %}
That sounds like a Java abstract class.
{% endnote %}

**Definition:**
A **category** consists of two things:
* objects, i.e. the elements in the set.
* morphism, a fancy way to say function, need to be composable.

If you think about this, *catagories* are all around us.
For example, as we defined before, $(\mathbb{R}, +)$ is a category where
* object: real number,
* morphism: $+$.

Group:
* object: elements of the set
* morphism: binary operation defined on it.

Monoid:
* object: elements of the set
* morphism: binary operation defined on it.

Vector space,
* object: vector
* morphism: scalar product

Metric space:
* object: elements of the sequence
* morphism: the continuous function defined on it.

Linked List:
* object: node
* morphism: `next`

Tree/Group:
* object: node
* morphism: path

Bushiness Plan:
* object: state/revenue
* morphism: action.

...

In theory,
anything in any subject can be defined as category,
as long as we can find its **objects** and define a morphism between them.
That is what I mean by "Object Oriented Mathematics".

### Monad

**Definition:**
A morphism mapping a category to another category is called a **functor**.

As we said, functions can map anything.
So the mapping between catagories should be no surprise.
In fact, we have already seen some functor.

Recall the <u> general linear group </u> $GL_N\mathbb{R}$,
$GL_N$ is just a function that maps a vector space (a catagories) to a group (another category).

`Maybe` we introduced in [Maybe Another Way of Error Handling ...](/2021/03/24/Maybe/index.html)
is also a functor.
`Maybe` maps a category of arbitrary type to a category of the same type that can can have error.
For example, we defined a type `Maybe Double`, which is a category of `Double` with errors.
Moreover,
in Haskell, we call the functor `Maybe` as the **Maybe Monad**.

**Definition:**
A **monad** is a functor on monoids.

In functional programming,
monad is often used to handle operation that will have side-effect.

Since a language with no side-effect is useless,
but side-effects are not safe and may cause programs,
Monad is the solution to handle side-effects in a controllable level.

Therefore, in Haskell, we have some predefined useful monads
* `Maybe` monad
* `IO` monad
* ...

### Monadic Map

The whole idea of functional programming is function composition.

However, with monad involved,
we get a problem (as last time we try to compose with `Maybe` monad).

Consider two general functions, 
* $f : B \rightarrow C$,
* $g : A \rightarrow B$.

Then there is a function $h = f \circ g$ as the composition of $f$ and $g$ such that
$$ h : A \rightarrow C. $$

But now with monad $M$, type of our two functions becomes
* $f : B \rightarrow MC$,
* $g : A \rightarrow MB$.

Then the types of two functions do not line up.
$f$ returns a $MB$ type, but $g$ takes a $B$ type,
so we cannot compose $f$ and $g$.

Recall in [Maybe Another Way of Error Handling ...](/2021/03/24/Maybe/index.html)
je use `>>=` the bind operator to solve this problem.
How does this work?

As defined, a monad is a functor, which is a mapping.
Consider the mapping
$$
\begin{matrix}
    & & A & \rightarrow & MA \\\\
    & & \downarrow & \swarrow & \downarrow \\\\
    B & \rightarrow & MB & \leftarrow & MMB \\\\
    \downarrow & \swarrow & \downarrow & & \\\\
    MC & \leftarrow & MMC & & 
\end{matrix}
$$

this map is called the **monadic map**,
which is how `>>=` compose two monadic functions.

{% note secondary %}
Can ypu tell how `>>=` compose two monadic functions?
{% endnote %}

Back to the question we propose in [Maybe Another Way of Error Handling ...](/2021/03/24/Maybe/index.html)

{% note secondary %}
We said `>>=` is a composition operator,
but why it does not take two functions?
{% endnote %}

We said binary operator should be symmetric,
but `>>=` is not.
The current `>>=` works as

Let's redefine $f$ and $g$ in Haskell code since `>>=` is a Haskell operator.

```haskell
g :: a -> M b
f :: b -> M c
```

Then the definition of `>>=` is

```haskell
(>>=) :: Monad m => m a -> (a -> m b) -> m b
```

and we use it as

```haskell
M b >>= (b -> M c)
```

which returns a `M c`.

But our goal is to compose a function that maps `a -> Mc`,
whereas our bind function is not taking an `a` as input.

Consider this way, the type signature indicates that `>>=` works as

```haskell
(ga) >>= \b -> (fb)
```

But if we make the expression an lambda expression,
i.e. add lambda to left,
it becomes 

```haskell
\a -> [(ga) >>= \b -> (fb)]
\a -> (ga) >>= \b -> (fb)
```

then `>>=` is actually symmetric as our normal composition operator:
takes two functions
* `g :: a -> M b`
* `f :: b -> M c`

and returns a function `h :: a -> M c`.



