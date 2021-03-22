---
title: How does lambda build up the world?
date: 2021-03-21 17:48:15
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

# Everything is Function

## Boolean Algebra Revisit

Boolean is a value that is either true or false.
Algebra somehow means functions.
Are Boolean functions?

```cpp
bool condition;
int a = (condition) ? val1 : val2;
```

This syntax is supported in most programming languages.
That is, we use the boolean condition to *select* between two values.
If the condition is true, we select `val1`,
otherwise we select `val2`.

Let's write functions that do these things.
Let function true as $T$ takes choose the first among its two inputs,
$$ T = \lambda ab. a = K $$
then it's just the Kestrel defined in last post!
Then define false as $F$ which returns the second input,
$$ F = \lambda ab.b = KI $$
which is the Kite.

Now the question is about the other boolean logics.
The first and the most important is **negation**,
the `!` in most programming languages.
Come to think about this,
the function $\mathrm{Not}$ takes one boolean input and return the negation of it.
That is,
* if the input is true (select the first), we return false;
* if the input is false (select the second), we return true.

Then we can define
$$ \mathrm{Not} = \lambda p. pFT $$
and if we express the idea of $N$ verbosely
$$\begin{align}
    \mathrm{Not}\ T & = F \leftrightarrow \lambda (\lambda ab.a) . (\lambda ba.a) \\\\
    \mathrm{Not}\ F & = T \leftrightarrow \lambda (\lambda ba.a) . (\lambda ab.a)
\end{align}$$
we can see $Not$ is doing reverse application!
Negation is just the Cardinal!

To find the $\mathrm{And}$ function, we can look at the truth table of and first

|$x$|$y$|$\mathrm{And}\ x y$|
|:--:|:--:|:--:|
|T|T|T|
|T|F|F|
|F|T|F|
|F|F|F|

There are two cases:
* If $x$ is true, then $\mathrm{And}\ xy = y$;
* If $x$ is false, then $\mathrm{And}\ xy = F$.

Therefore, the $\mathrm{And}$ may involve some function that choose between two inputs.
Recall that $T$ and $F$ are the two functions choosing between inputs!
And $T$ and $F$ are the possible candidates of $\mathrm{And}$!
Let
$$ \mathrm{And} = \lambda xy. xyF $$
then $\mathrm{And}$ satisfies the description above.

> Think about the case when $x$ is false, can we have another definition of $\mathrm{And}$?

|$x$|$y$|$\mathrm{Or}\ x y$|
|:--:|:--:|:--:|
|T|T|T|
|T|F|T|
|F|T|T|
|F|F|F|

$\mathrm{Or}$ is very similar to $\mathrm{And}$.
* If $x$ is true, then $\mathrm{Or}\ xy = T$;
* If $x$ is false, then $\mathrm{Or}\ xy = y$.

Then we can give the $\mathrm{Or}$ function
$$ \mathrm{Or} = \lambda xy. xTy $$

> Like $\mathrm{And}$, is there another way to define $\mathrm{Or}$?

|$x$|$y$|$\mathrm{Xor}\ x y$|
|:--:|:--:|:--:|
|T|T|F|
|T|F|T|
|F|T|T|
|F|F|F|

As the definition of xor,
when two inputs are the same, it returns ture;
otherwise it's false.

* If $x$ is true, then $\mathrm{Xor}\ xy = \mathrm{Not}\ y$;
* If $x$ is false, then $\mathrm{Xor}\ xy = y$.

$$ \mathrm{Xor} = \lambda xy. x\ (\mathrm{Not}\ y) y $$
This also the $\neq$ operator.

In conclusion, when defining binary boolean functions,
we use the first input as a selecter.
> How to define $\equiv$ the `beq` operator using lambda calculus?




