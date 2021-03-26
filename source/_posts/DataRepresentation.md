---
title: "Data Representation"
date: 2020-10-18
tags:
  - Note
  - assembly
  - HackerHub
category: Science
---

# Binary Representation

Everything in the computer is represented using a very simple binary coding scheme where the only symbols used are 0 and 1.

* **Magnetic disks**: magnetic material can be polarized to one and two extremes ("north" or "south") to represent a 0 or a 1.
* **Memory**: each bit can be thought of as an electronic switch that is either off or on representing a 0 or a 1, or, depending on how the memory is made, as collections of electrons. (In old days, memory literally was tiny circular magnets, but no longer.)
* **CDs/DVDs**: the surface consists of smooth areas and pits representing 0's and 1's respectively.
* **Bus (wire)**: voltage or current

## What can be represented by bits?

* a bit (short for "binary digit") is the fundamental data component: either a 1 or a 0
* 8 bits** is called a **byte**, A byte can represent:
  * 256 different numbers
  * 256 different characters from your keyboard (Programming languages typically use 2 byte to represent a character)
  * 256 different shades of gray in a black and white image
  * 256 colors or shades of color in a color image
  * 256 frequencies or tones to be played through a speaker
  * 256 of anything that can be *represented as discrete entities* 
* the max value for $n$ bits is $2^{n-1} - 1$, whereas the min value is $-2^n$.

# Number System

| **Base 10** | **Base 2** | **Base 8** | **Base 16** |
| :---------: | :--------: | :--------: | :---------: |
|      0      |    0000    |     0      |      0      |
|      1      |    0001    |     1      |      1      |
|      2      |    0010    |     2      |      2      |
|      3      |    0011    |     3      |      3      |
|      4      |    0100    |     4      |      4      |
|      5      |    0101    |     5      |      5      |
|      6      |    0110    |     6      |      6      |
|      7      |    0111    |     7      |      7      |
|      8      |    1000    |     10     |      8      |
|      9      |    1001    |     11     |      9      |
|     10      |    1010    |     12     |      A      |
|     11      |    1011    |     13     |      B      |
|     12      |    1100    |     14     |      C      |
|     13      |    1101    |     15     |      D      |
|     14      |    1110    |     16     |      E      |
|     15      |    1111    |     17     |      F      |

## Signed Numbers

### Signed Magnitude

* the left-most bit in the binary number is the sign
    * 0 is **positive**
    * 1 is **negative**
* $00000011_2$ is $+3_{10}$
* $10000011_2$ is $-3_{10}$

## Two's Complement

take opposite of each bit, then add one

# Characters

## ASCII

American Standard Code for Information Interchange

* A-Z: 65-90
* a-z: 97-122
* 0-9: 48-57

## Unicode

addition to ASCII that can represent more characters, covers lots of emojis and most existing languages.

[More Information](https://www.unicode.org/versions/)
