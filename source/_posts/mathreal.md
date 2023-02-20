---
title: Mathematical Realism
date: 2023-02-19 21:19:13
tags:
  - philosophy
  - math
category: Philosophy
---



# What is mathematical realism and what problems does it face?

Mathematical realism is a philosophy view that 
believes mathematical objects,
such as numbers, sets, functions, groups, rings
exists independent of us,
the way they are in mathematical realm fixes truth,
and we came to know those objects directly or indirectly through some experiments.
That means that mathematical objects were discovered, 
rather than invented, 
and their properties are independent of our beliefs or attitudes towards them.
There are a few problems it faces,
two of them are the problem of epistemic access and the problem of ontology.

## Problem of Ontology and Epistemic Access

These two questions we are going to discuss are related to
the existence of mathematical objects and its relationship with us.
The problem with *ontology* is the question of
what kinds of objects exist in the mathematical domain, and how we can determine their properties and relations.
In other words, what object is considered mathematical object?
For example, is semi-groups considered mathematical object or 
a collection of mathematical objects that have associative binary operator defined?

```haskell
class Semigroup a where -- associative binary operator
  (<>) :: a -> a -> a -- a <> (b <> c) == (a <> b) <> c

class Semigroup a => Monoid a where -- with identity element
  mempty :: a -- a <> mempty == a
```
The same idea also apply to other structures like monoid, group, rings, etc.


In addition to the problem of *ontology*,
the problem with *epistemic access* mainly states that
if mathematical objects exists independently of us,
how do we have knowledge about them?
When viewing mathematical objects as abstract objects,
we cannot gain knowledge or experience of them directly.

## Mathematical Nominalism

Since there are problems with mathematical realism,
mathematical nominalism is an alternative view to avoid the problem of "independent of us".
On this position, 
mathematical objects are true only in a conventional or linguistic sense,
or they are just names given by mathematicians.
Since objects are just names in the language,
there is no problem with access as how we defined the language.
However, mathematical nominalism faces problems like
the reliability of mathematical objects and the usefulness of mathematical
since objects now are just names given in a language.
