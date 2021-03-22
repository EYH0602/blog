---
title: Introduction to Lambda Calculus
date: 2021-03-20 20:55:17
tags: 
  - Note
  - math
  - algebra
  - Haskell
  - functional
  - programming
  - logic
  - HackerHub
category: "Science 👨‍💻"

---

# Lambda Calculus

If you come from imperative programming,
you might heard about the **lambda expression**.
That is also called the "anonymous function".
This is a concept borrowed from functional programming
(the word "function" kind of indicates that LOL).

> When I first encounter the idea of "anonymous function",
> I did not understand the meaning of it.
> To me, it is more like a quick way to define simple method when I was too lazy.

But what really is Lambda calculus?
It is a simple **notation system** developed by 
[Alonzo Church](https://en.wikipedia.org/wiki/Alonzo_Church)
to represent [Combinatory logic](https://plato.stanford.edu/entries/logic-combinatory/).
Lambda calculus is also the base of Functional programming,
similar to what binary code and later assembly language means to imperative languages.

From here, 
we can see the main difference between imperative programming and declarative programming:
* imperative programming build up from the hardware level, telling the computer what to do.
    Then we build up the abstraction as possible.
* declarative programming starts from logic,
    then try to reduce abstraction for computer to understand
    (that the compiler's job, we only worry about logic).

A lambda expression is just a function with out a name, a mapping, as
$$ \lambda x . x $$
which is just the identity function.

In Haskell, the syntax is
```haskell
\x -> x
```
since we do not use unicode in programming,
the character `\` the closed one to $\lambda$.

## Currying

Theoretically,
lambda calculus does not allow the function to take more than one input.
That is why we define binary operation as
$$ * : S \times S \rightarrow S $$
which takes a pair of numbers as input and returns a number.

This way of defining function is not very efficient,
we want out function to take as much inputs as we want.
mathematician [Haskell Brooks Curry](https://en.wikipedia.org/wiki/Haskell_Curry)
develops an idea to solve this problem.

> There are three programming languages name after him,
> Haskell, Brook, and Curry.

The idea is that,
for the function to take two inputs,
iwe can to define a function that takes one input
then returns a function that
also (takes one input and returns one output).
That is, for a binary operation, we write
$$ * : S \rightarrow (S \rightarrow S) $$
and the parenthesis can be ignored.

In lambda calculus, we write the binary operation as
$$ \lambda x. (\lambda y. x * y) \equiv \lambda xy. x * y $$

With this idea in mind, we can play with some haskell functions.
For example, we know addition takes two numbers and return their sum,
what happens if we only give it one input?

```haskell
Prelude> :t (+)
(+) :: Num a => a -> a -> a
Prelude> :t (+1)
(+1) :: Num a => a -> a
Prelude> 1 + 2
3
Prelude> (+1) 2
3
```

We also even give the returned function a name

```haskell
Prelude> add1 = (1+)
Prelude> add1 10
11
Prelude> map add1 [1..10]
[2,3,4,5,6,7,8,9,10,11]
```

In this way, we can also define our own functions with defining the inputs

```haskell
getEven :: Integral a => [a] -> [a]
getEven = filter even
```

This way of defining function is called **wholemeal programming**,
which is the idiomatic Haskell style.

## $\beta$-Reduction

$\beta$-Reduction is a way to simplify a complex lambda expression.
The idea is very simple,
we can plug the input into the lambda expression and see what happens.

For [example](https://www.youtube.com/watch?v=3VQ382QG-y4&t=561s),
$$
\begin{align}
    & ((\lambda a. a)\lambda b. \lambda c. b)(x) \lambda e.f \\\\
    & = (\lambda b.\lambda c.b)(x) \lambda e.f \\\\
    & = (\lambda c. x) \lambda e. f \\\\
    & = x.
\end{align}
$$

After we fully evaluate the function, we call it a **$\beta$-normal** form.

## Combinatory Logic

**Definition:**
A **combinator** is a lambda expression that has no *free variable*.
That is, the output can only be its inputs.

Recall that we can pass a function as argument.
Let's define a **self-application** function
$$ M = \lambda f. ff $$
which is often called the **Mockingbirds**.

> Imagine you are in a forest inhabited by talking birds.
> Given any birds $A$ and $B$ in the forest,
> if you call out the name of $B$ to $A$,
> then $A$ will respond by calling out the name of some other bird to you.
> Then by the name of Mockingbird,
> $$ Mx = xx $$
> the bird $M$'s response to any bird $x$ is the same as $x$'s response to itself.
> It *mimics* $x$ as far as $x$'s response to $x$ goes.
>
> This idea comes from the book 
> ["To Mock a Mockingbird"](https://en.wikipedia.org/wiki/To_Mock_a_Mockingbird)
> by Raymond Smullyan.
> It is a great book about combinatory logic and some other logic puzzles, 
> very recommended.

Then we define **Kestrel**,
$$ K = \lambda ab. a $$
which takes two inputs and returns the first parameter.
Haskell provide function `const` as the Kestrel,

```haskell
const :: a -> b -> a
```

Thinking about the name `const`, let's define
```haskell
const1 :: Num a => b -> a
```
then,
```haskell
Prelude> const1 2
1
Prelude> const1 5
1
Prelude> const1 10
1
Prelude> map const1 [1..10]
[1,1,1,1,1,1,1,1,1,1]
```

The beauty of combinatory logic, as well as Functional programming,
is that
with identity, Mockingbird, and Kestrel, we can create the world.

What if we want the the second parameter instead of the first one?
In the trivial way, we might define the function as $\lambda ab. b$.
But if we think about this, we can identity as  Kestrel's input
$$ KIx = (\lambda ab. a)(\lambda a. a)x = \lambda x.x = I  $$
which is the identity!
Then we can try to apply this function to some value
$$ KIxy = Iy = y. $$
Let's call the function $KI$  **Kite**.

```haskell
kite :: a -> b -> b
kite = const id
```
then 
``` haskell
Prelude> kite 1 2
2
Prelude> kite 3 2
2
Prelude> kite 3 1
1
```

Another fundamental combinator is the **Cardinal**, 
$$ C = \lambda fab. fba $$
which is the *reverse application*.
This is defined as the `flip` function in haskell.

```haskell
flip :: (a -> b -> c) -> b -> a -> c
```

```haskell
Prelude> combineStr a b = show a ++ show b
Prelude> :t combineStr 
combineStr :: (Show a1, Show a2) => a1 -> a2 -> [Char]
Prelude> combineStr 1 3
"13"
Prelude> flip combineStr 1 3
"31"
Prelude> 
```

And the most important one is composition of functions!
That is the reason why we talk about functional programming.
Define the **Bluebird**
$$ B = \lambda fga . f(ga) $$
to be the composition combinator.

In Haskell, as shown in last post, is

```haskell
(.) :: (b -> c) -> (a -> b) -> a -> c
```

Theoretically,
using Kestrel and Cardinal we can get all the possible combinators.
So there might be a way to compile any functional program into these two combinators.
> Can we build a working computer with only Kestrel and Cardinal?
For more information, visit
* [Functional Programming with Combinators](https://core.ac.uk/download/pdf/82459455.pdf).
* [Lambda Calculus - Fullstack Academy](https://www.youtube.com/watch?v=3VQ382QG-y4&t=561s).

**Note.**
If yuo want to try out the bird names in Haskell,
there is a library for that
[Data.Aviary.Birds](https://hackage.haskell.org/package/data-aviary-0.4.0/docs/Data-Aviary-Birds.html)



