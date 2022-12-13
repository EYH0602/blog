---
title: proxytunnel on MAC
date: 2022-12-13 14:18:17
tags: note
category: Tech
---

# Use Proxytunnel on M1 Mac

When trying to connect from my M1 mac t the lab's servers,
I failed multiple times and had to use my old windows laptop to connect from WSL.
Our server requires a proxy jump for security reasons,
so we use the following lines in the `ssh_config` file

```sh
Host hostname
    ProxyCommand proxytunnel -E -p hostname:port -d %h:%p
```

To install `proxytunnel` on Mac,
upon google "proxytunnel mac",
the top 2 links will take us to **Homebrew Formulae**,
which is a popular package manage on Mac.
To install `proxytunnel`, the webpages suggest

```sh
brew install proxytunnel
```

With successful installation with `brew`,
when I try to ssh,
the following error message appears

```sh
> ssh me@hostname
Via hostname:port -> hostname:22
Certificate verification failed (unable to get local issuer certificate)
kex_exchange_identification: Connection closed by remote host
Connection closed by UNKNOWN port 65535
```

I tried to solve this problem,
but there is no discussion nor solution on the internet.
I blamed this on the M1 chip, but I was wrong.

## How to fix

It turns out,
although `brew` said the install is successful,
the dependence of `proxytunnel` is not complete.
My current solution is to uninstall it from brew and reinstall with **MacPorts**.

If you have MacPorts installed, then
```sh
brew uninstall proxytunnel
sudo port install proxytunnel
```
then `ssh` should be working with the same commands.
