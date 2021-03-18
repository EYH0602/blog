---
title: "Setting Up PostgresSQL on Ubuntu"
date: 2020-09-26
tags:
  - Linux
  - PostgresSQL
  - SQL
  - "Database System"
  - Note
category: Tech
---

# PostgresSQL

This blog is a note for myself about setting up PostgreSQL on Ubuntu devices, as a preparation for UC Davis ECS 165A.
Although this blog is about PostgreSQL, other SQL languages (MySQL, ...) should be very similar to begin.
The steps should also be the same for all Debian-based Linux Distros.

## Get PostgreSQL

The following scripts are from [Postgresql official website](https://www.postgresql.org/download/linux/ubuntu/).

```shell
# Create the file repository configuration:
sudo sh -c \
  'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > \
  /etc/apt/sources.list.d/pgdg.list'

# Import the repository signing key:
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Update the package lists:
sudo apt-get update

# Install the latest version of PostgreSQL.
# If you want a specific version, use 'postgresql-12' or similar instead of 'postgresql':
sudo apt-get -y install postgresql
```

## Get an IDE

Or just just the command line ...

Since I am new to SQL, I think an IDE may help me to learn faster. 
For now, my choice is **DataGrip** from JetBrains. Since I'm using my education account, it is free.

We can install JetBrains' application directly from Snapcraft.

```bash
sudo snap install datagrip --classic
```

But for some unknown reason, snap apps are very slow to start and run,
so I prefer to download and install from JetBrains [DataGrip website](https://www.jetbrains.com/datagrip/download/#section=linux).
