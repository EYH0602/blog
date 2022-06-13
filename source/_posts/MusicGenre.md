---
title: "Music Genre"
date: 2022-6-12
tags:
  - Computer Science
  - Machine Learning
  - Deep Learning
  - NLP
  - Rock
  - Music
category: Science
---

# Predicting ROCK!!

Cover songs played an important in the history of Rock music. Some artists keep their cover songs close to the original version, while others alter the song to a great extent. Although some critics consider cover songs as less legitimate compared to original songs, covering a song brought out new insight and understanding of the music from a different perspective. As for Rock music, cover songs are considered a diffusion of the rock n roll rock aesthetics into other genres. High Hopes, the last song of the album The Division Bell by Pink Floyd, has been covered by artists in the various music genre. In this blog, we demonstrate and discuss the difference in the Pink Floyd version and the Nightwish cover version in terms of music and from a data science perspective.

## Music Comparison

Different arrangements of the performance sometimes alter the meaning of the song and often appeal to different emotions. In the song High Hopes, the different utilization and arrangement of music elements contribute greatly to the meaning of their music. In the Pink Floyd version, the song is divided into two parts by the instrumental harmony (mainly guitar solo by David Gilmour) around the third minute. It is noticeable that both parts of the song are introduced with the cooperation of the piano and a bell (the Division Bell), giving the audience a calm and comfortable feeling. But at the same time, the ringing bell also keeps reminding the audience to keep in mind something. In this case, it represents the author's thinking about the simple and beautiful past in comparison to the mysterious and complex current. This emotion is pushed to the climax by the guitar solo after each verse, leaving an endless aftertaste at the end of the Hawaiian Steel Guitar solo (also the end of the song).

Nightwish, on the other hand, replaced the piano and bell with a keyboard with synthesizers, which creates a sharper and thriller sound of the same rhythm created by the piano and the bell. Through each verse, Nightwish raises the audience's emotion of questing and anger by guitar riff Marko Hietala's high patch singing. Instead of sitting alone thinking about the past and current as described in David's solo, Marko uses his voice to question the future, regardless of what the past is like. The Nightwish's cover version is also notably faster than the Pink Floyd version, which provides more energy to the music, providing the power of their screaming to the future.

Although the music from these two bands is distinct, the same lyrics were fitted well. The lyrics of High Hopes focus on describing a place in the past and the feelings of revisiting the place. The music of the Pink Floyd version expresses a conflict between the current situation and the past and draws a picture wandering between these two periods. Nightwish uses the music to show their wish for the future based on the current and past described in the lyrics. Both bands bring out different perspectives of the lyrics with their different version of music.

## A Comparison Based on Data

This experiment is based on the [GTZAN](https://www.kaggle.com/code/andradaolteanu/work-w-audio-data-visualise-classify-recommend/) dataset, which contains a total of 1000 audio files in 10 different genres. The dataset also contains spectrogram images of every song as an image representation. In this experiment, we randomly shuffle the order of spectrograms of the songs, then divide the dataset into groups of 800, and 200 for train and test. The classifier model is composed of 5 convolution layers that can extract features from the spectrograms. We use the Cross-Entropy loss function and Adam to train the model. The model is trained for 100 epochs and get a 95% test accuracy.

![bar](/images/bar2.png)

Due to the design of model design, the feature comparison is limited to 30-second audio clips. As a result, this experiment focuses on the clips of the introduction, the refrain (chorus), and the first guitar solo (note that Nightwish did not perform the ending solo). Surprisingly, the classifier gives a high probability of blues for both versions. In particular, the prediction on the introduction of Pink Floyd's version, the chance is similar between metal, rock, and blues. In comparison, the Nightwish version introduction is considered more like pop, blues, or metal due to the rhythm played by the keyboard. The other music samples taken from both versions are considered blues or pop music. The Saliency maps also conform with the music analysis of the first part and the above prediction that the features in the introductions are distinct, but the singing and guitar solo are similar. It is also noticeable that the lower frequency part of both versions contributes more to the genre prediction by the model, as denoted by the darker color in the Saliency maps.

![saliency](/images/saliency2.png)

## Conclusion
From both the music side and data side, we can see that although the audience considers two versions as rock and metal, the rhythm and arrangement are still close to blues. This prediction error is most likely contributed by the timber of the instruments, especially the level of distortion. To improve the results and get a clear observation, future studies may be done using larger datasets and viewing each song as a whole piece instead of taking 30-second samples.

The code used to train the model and get the results is available at https://github.com/EYH0602/MusicGenre.

