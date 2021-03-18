---
title: "OneDrive and WeChat"
date: 2020-08-28
tags:
  - Linux
  - Ubuntu
  - OneDrive
  - WeChat
category: Tech
---

# Setup Ubuntu for a Windows user

Last Year I found my EDC hp laptop is super slow and hot running Windows 10 and WSL, so I installed Ubuntu 18.04  Bionic Beaver (Of course, updated to 20.04 now). Today when I am playing with my main computer (MSI GS65), I accidentally delete the startup drivers for my Windows 10. But instead of reinstalling Windows, I think this is a good time to switch to Linux community "completely".

Last year I also tried Ubuntu on my MSI laptop, but it was very hard to get my Nvidia graphics working. 
So this time, I choose the newest [Pop!_OS](https://pop.system76.com/) with Nvidia drivers pre-buildin as my main operating system. It also looks very pretty 😆 !

For the past year, there two concerns stopping me to go complete Linux

1. [OneDrive](#OneDrive): All my files are stored on OneDrive, but there is not a good sync application on Ubuntu that is free as it on windows.
2. [WeChat](#WeChat): Sometimes I need wechat to communicate, especially for people like me who don't look at their phone at work. Now wechat is getting banned, so this worry does not exist anymore.

Thankfully I manage to find a free open-source OneDrive client on GitHub. This blog is for me to remember the setup process so it could be easier next time.

## OneDrive

### Installation

Here is the github repo for this app: [OneDrive Client for Linux](https://github.com/abraunegg/onedrive).

First we need the dependencies:

```shell
sudo apt update
sudo apt install libcurl4-openssl-dev libsqlite3-dev build-essential pkg-config
```

We also need `dlang` , we can find the `.deb` package [here](http://downloads.dlang.org/releases/2.x/2.093.1/dmd_2.093.1-0_amd64.deb). Then install it:

```shell
sudo apt install ~/Downloads/dmd_2.093.1-0_amd64.deb
```

Then manually install the app:

```shell
git clone https://github.com/abraunegg/onedrive
cd onedrive
./configure
make
sudo make install
```

### Setup

After the installation, we need to set up the program on the first run:

```shell
onedrive
```

Then a link will appears on the terminal, click it, open in any browser, and login to Microsoft account. After login, the web page will turn to blank. At time time, copy the url of this blank page and paste into the terminal, then hit ENTER. BOOM!! Setup finished!

Then we need to sync the files onto the new computer:

```shell
onedrive --synchronize
```

This would take several hours, depends on your total file size on OneDrive and you network. This process can be stopped, just use the same command to continue.

Here is something useful: in your `.zshrc`

```shell
alias sync="onedrive --synchronize"
alias monitor="onedrive --monitor"
```

For a more detailed usage description, look at its `man` page:

```shell
man onedrive
```

## WeChat

Since Tencent will not launch a Linux version, we need to use [wine](https://www.winehq.org/).
For WeChat and other Chinese applications, it is easier to use the open-source [deepin-wine](https://github.com/zq1997/deepin-wine).
For Chinese version of this part, please read the README page for this repository.

First, get the repository onto our list:

```shell
wget -O- https://deepin-wine.i-m.dev/setup.sh | sh
```

Then we can easily use the `apt` package manager to install the apps we need.

```shell
sudo apt install deepin.com.wechat
```

For other Chinese app with no Linux support:

|Name|Package name|
|:---|:---|
|微信|`deepin.com.wechat`|
|QQ|`deepin.com.qq.im`|
|TIM (QQ office 版)|`deepin.com.qq.office`|
