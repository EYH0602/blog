---
title: Be Careful Using Python Iterator
date: 2023-08-20 20:02:50
tags:
  - python
  - computer science
  - programming
  - functional
category: Science
---

# Be Careful Using Python Iterator

In a recent experiment, I encountered a bug where all the results were shown as negative.
After debugging, I found that the bug was caused by using the same iterator twice.
My library API was designed to take a list of tuples as input,
but when I called it later, I passed in a `map` object.

My API extracts the first and second elements of the tuple and
uses them independently to obtain the experiment results.
However, every time I ran the experiment,
the list of second elements was empty,
resulting in all negative results.

So, the key takeaway is that **a Python iterator can only be consumed once**!!

## Reproduction

```python3
def foo(x: int) -> tuple[int, int]:
    return (x, x + 1)


xs = [1, 2, 3]

# case 1: list comprehension
ys = [foo(x) for x in xs]
ys_fst = [y[0] for y in ys]
ys_snd = [y[1] for y in ys]

# case 2: map
zs = map(foo, xs)
zs_fst = [z[0] for z in zs]
zs_snd = [z[1] for z in zs]

print(ys_fst == zs_fst)
print(ys_snd == zs_snd)
```
