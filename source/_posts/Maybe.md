---
title: Maybe Another Way of Error Handling ...
date: 2021-03-24 22:23:36
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

# Errors!

Throw exceptions!

That seems simple,
but is it?
Let's define a simple function with some boundary conditions.
For example, division is undefined if the denominator is 0.

```cpp
// calculate a/b
double safeDiv(double a, double b) {
    if (b == 0.0) {
        throw runtime_error("Exception: Denominator Cannot be 0.")
    }
    return a / b;
}
```

What's wrong with this function?
At the very first line,
we defined `safeDiv` as a mapping take takes two `double` and returns a `double`.
But when the function throw a runtime error,
does it return a `double`?
Then, out function header is lying to us!

As a careful programmer,
we always want out function to be honest.
In a program, the type of a function should indicate what the function does.

## Maybe it Returns a ...

Let's stay on the example of `safeDiv`.
Since the denominator cannot be 0
if we get a 0 for the denominator but cannot throw an exception,
what should we do?
In this case, the return value cannot be a `double` neither.

Actually,
we say the safe division maybe returns a double, or nothing.
* if the denominator is 0, `safeDiv` returns Nothing,
* otherwise, it returns just the division.

That is,

```haskell
safeDiv :: Double -> Double -> Maybe Double
safeDiv _ 0 = Nothing
safeDiv a b = Just (a / b)
```

it returns

```haskell
*Main> safeDiv 1 4
Just 0.25
*Main> safeDiv 3 0
Nothing
```

which is exactly what the type signature tells us!

This idea words on more generic function too.
For example,
when we want the head of an empty list,
there would be an error

```haskell
Prelude> head []
*** Exception: Prelude.head: empty list
```

We can define a `safeHead` function to solve this problem,

```haskell
safeHead :: [a] -> Maybe a
safeHead [] = Nothing
safeHead (x : _) = Just x
```

our we can just use the Prelude `head`

```haskell
safeHead :: [a] -> Maybe a
safeHead [] = Nothing
safeHead xs = Just (head xs)
```

this will give us 

```haskell
*Main> safeHead [1..5]
Just 1
*Main> safeHead []
Nothing
```

## Composition with Error

Function composition is the highest call in functional programming.
For example, if we want to convert a division result to string

```haskell
*Main> show (5/3)
"1.6666666666666667"
*Main> show (5/0)
"Infinity"
```

The type signature of `show` is

```haskell
show :: Show a => a -> String
```

and if we compose it with `show` with our `safeDiv`

```haskell
*Main> show $ safeDiv 5 0
"Nothing"
*Main> show $ safeDiv 5 3
"Just 1.6666666666666667"
```

we will need another parser to extract the division result.

In a simple way,
we may define a `safeShow` to solve this problem.

```haskell
safeShow :: Maybe Double -> String
safeShow Nothing = ""
safeShow (Just a) = show a
```

```
*Main> safeShow $ safeDiv 5 3
"1.6666666666666667"
*Main> safeShow $ safeDiv 5 0
""
```

But our `safeShow` only handles the `Maybe Double` type.
We cannot compose it with other type functions,
which contradicts the idea of function reusability.

Ideally, we want to keep `show`'s generic type in our `safeShow`,
while extracting the result easily and quickly.

To solve these two problems, we may define `safeShow` as
* if `safeShow` receives nothing, it returns nothing
* otherwise it returns just the `show` of the value

We introduce the `>>=` bind operator.
Let's see how it works.
First, we can define the `safeShow` as we want:
it takes any showable type and the return type maybe is string.

```haskell
safeShow :: Show a => a -> Maybe String
safeShow = Just . show
```

Then we can try in `ghci`
```haskell
*Main> safeDiv 5 1 >>= safeShow
Just "5.0"
*Main> safeDiv 5 0 >>= safeShow
Nothing
*Main> safeHead [1..5] >>= safeShow
Just "1"
*Main> safeHead [] >>= safeShow
Nothing
```

`>>=` is the composition operator of functions that return a Maybe type!
What's its type in this case?

```haskell
(>>=) :: Maybe a -> (a -> Maybe b) -> Maybe b
```

This function takes two inputs
* `Maybe a` as the output of our other `safe*` functions;
* a function that map `a` to `Maybe b` type.

{% note secondary %}
The actual type of `>>=` is
```haskell
(>>=) :: Monad m => m a -> (a -> m b) -> m b
```
You may wonder what is `Monad m`, 
and as mentioned before in type signature of `show`, `Show a`.
We said `Show a` means "showable" type.
In fact, the keywords `Monad` and `Show` are type class.
Visit blog post ["Types! What are They?"]().
{% endnote %}

{% note secondary %}
We said `>>=` is a composition operator,
but why it does not take two functions?
If you are interested in that,
visit blog post ["Object Oriented Mathematics !?"]().
{% endnote %}

{% note info %}
For more information,
visit [A Fistful of Monads](http://learnyouahaskell.com/a-fistful-of-monads).
{% endnote %}
