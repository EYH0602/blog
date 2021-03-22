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
the function $N$ takes one boolean input and return the negation of it.
That is,
* if the input is true (select the first), we return false;
* if the input is false (select the second), we return true.

Then we can define
$$ N = \lambda p. pFT $$
and if we express the idea of $N$ verbosely
$$\begin{align}
    N\ T & = F \leftrightarrow \lambda (\lambda ab.a) . (\lambda ba.a) \\\\
    N\ F & = T \leftrightarrow \lambda (\lambda ba.a) . (\lambda ab.a)
\end{align}$$
we can see $N$ is doing reverse application!
Negation is just the Cardinal!

