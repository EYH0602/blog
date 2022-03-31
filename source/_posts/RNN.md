---
title: "How Did I Failed RNN"
date: 2022-3-26
tags:
  - Computer Science
  - Machine Learning
  - Deep Learning
  - NLP
category: Science
---

# Why is RNN more difficult to work with them MLP or CNN?

This is, of course, an open question.
But for me, the troubles are majorly caused by text embeddings.

The problem we encountered was to load the text embedded vector into the gRAM
(both 6GB on my local GTX 1660Ti and gcloud 12GB Tesla K100).

The problem was fixed before the deadline with the utilization of `torchtext`.
We did not change any of the tokenize methods,
but used `BucketIterator` from `torchtext` to feed data into the network
instead of batching the embeddings ourselves.

Without reading the implementation of `torchtext`,
I'm guessing the package utilizes some kind of easy-loading technics.

For code example and how to use `torchtext.data`, checkout
* [original implementation](https://github.com/EYH0602/ECS189G_DeepLearning/blob/fa309e6453f2b687cfb7e6d0f26006dc66bd346f/code/stage_4_code/Dataset_Loader.py)
* [torchtext](https://github.com/EYH0602/ECS189G_DeepLearning/blob/main/src/stage_4_code/Dataset_Loader.py)

# Text Generation

Our model works, on some level.
Following [this tutorial](https://www.kdnuggets.com/2020/07/pytorch-lstm-text-generation-tutorial.html),
the model we build can be trained, but the jokes it generated are not understandable.

**ToDo**
analysis more on the LSTM on text generation task.
