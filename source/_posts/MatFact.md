---
title: "Relations Within the Matrix"
date: 2022-3-31
tags:
  - Computer Science
  - Linear Algebra
category: Science
---

# On Behalf of Matrices

Matrix Factorization methods are commonly used in machine learning related fields.
The utilizations are various, in many different sub-fields.

The holy idea behind this is that the problems of slow computation and overfitting are huge in ML-related tasks,
and if the data can be represented in a matrix,
the major cause of these problems is the rank of the matrix.

{% note primary %}
Note that in algebra, a matrix is a linear function (mapping).
For a matrix $A \in \mathbb{R}^{m \times n}$, it has type signature
$$
A \in \mathbb{R}^{m \times n} : \mathbb{R}^{m \times \cdot} \rightarrow \mathbb{R}^{n \times \cdot}
$$

And for any linear mapping $A$, the rank if this mapping is
$$
\mathrm{rank}(A) = \mathrm{dim}(\mathrm{img}(A))
$$
{% endnote %}

Therefore, for a input matrix $M_1$,
we want to find a matrix $M_2$ such that
* $M_2 \approx M_1$ and 
* $\mathrm{rank}(M_2) \ll \mathrm{rank}(M_1)$

which is the idea of *low-rank approximation*.

That is, we want to reduce the rank as much as possible and
keep the information as complete as possible.
How do we do this?

The first step is to know which information in the matrix is more important.
Keeping the more important information and drop the others can achieve the above desire.
As the names suggests,
these values should be the eigenvectors and correlations between values in the matrix.

## Principle Component Analysis

PCA for short.
If we have dataframes, or tables,
we can find out the 

From linear algebra,
we can find the eigenvalues of a matrix

* For given matrix $A$, find the eigenvalues and eigenvectors of $A$
* use the eigenvalues of $A$ to form a diagonal matrix $D$
* concat the eigenvectors into one matrix $U$
* reorder $D$ such that eigenvalues of $A$ are in decreasing order
* reorder rows $U$ in same order as $D$
* replace $U$ by taking first $s$ rows of $U$ where for given $s$
* $W = UX$ is the desired matrix after dimension reduced

in this case, $s$ is a parameter denoting the desired dimension.

{% note primary %}
One can find that
$$
UAU^{-1} = D
$$
{% endnote %}

{% note primary %}
Also note that the given matrix $A$, 
if we are doing PCA on images, $A$ is the image itself.
If we are doing ML on tabular data, $A$ is the covariance matrix of features in the table.
{% endnote %}

## Singular Value Decomposition

The famous SVD.
Idea behind SVD is very similar to $PCA$:
Denote the original matrix with some matrix multiplication of $D$ and some other matrices,
where we can use the order of eigenvalues to take first $n$ rows of these matrices
to achieve *low-rank approximation*.
Note that's also why its called *decomposition*.
Also, FYI that singular value is just the absolute value of eigenvalue.

In this case, the approximation for given $A$ would be
$$
A \approx UDV'
$$
which also can be written as
$$
A \approx WH
$$
where $W = UD^{0.5}$ and $H = D^{0.5}V'$.

Then the job left is to find $W$ and $H$ (well, to find $U$ and $V$).

There are different methods to find these two matrices.
As doing machine learning,
one clear approach is to do gradient descent.

Another notable way is Alternating Least Square, where the general idea is that
* random init $W$ as $W_0$
* use $W_0$ to find $H_0$
* use $H_0$ to find $W_1$
* continue until convergence or asked to stop

and the task here is to minimize $f(w, h)$ where
$$
f(w, h) = ||A - WH||_{F}^{2}
$$
with the Frobenius norm.

## Some Application

In Recommender Systems,
this methods are used for dimension reduction and matrix completion of the rating matrix.
However, as its name suggested, "Matrix Factorization" methods works on all matrices.
The completion of the rating matrix is not limited to these factorization method,
other machine learning algorithms can also predict the values.

In Computer Vision, or other ml-related tasks, these methods has more applications.
In [AlexNet](https://papers.nips.cc/paper/2012/hash/c399862d3b9d6b76c8436e924a68c45b-Abstract.html),
PCA is used as a data augmentation method to alter the intensities of RGB channels of the image.
SVD is also an import part of CV, dealing with image compression and image enhancement
(well, the same as dimension reduction and matrix completion since images are matrices).


