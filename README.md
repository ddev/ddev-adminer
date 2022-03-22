[![tests](https://github.com/bserem/ddev-adminer/actions/workflows/tests.yml/badge.svg)](https://github.com/bserem/ddev-adminer/actions/workflows/tests.yml) ![project is maintained](https://img.shields.io/maintenance/yes/2022.svg)

# DDEV Adminer Service

## What is this?

This repository allows you to quickly install Adminer database manager into a [Ddev](https://ddev.readthedocs.io) project using just `ddev get bserem/ddev-adminer`.

Adminer is a full-featured database management tool written in PHP. This service
currently ships the [official adminer container](https://hub.docker.com/_/adminer)
with no _external_ plugins. It contains all official plugins and themes and allows
to easily chose one by editing the `docker-compose.adminer.yaml` file after
installation.

The official container supports:

* MySQL / MariaDB
* PostgreSQL
* SQLite
* SimpleDB
* Elasticsearch

## Why?

Because you might need something other than MySQL / MariaDB in your DDEV project. We got you covered.

## Installation

* `ddev get bserem/ddev-adminer && ddev restart`

## Caveats

You need to pass database credentials manually for the time being. If you have
any ideas on how to overcome this issue please let me know.

Default ddev database credentials are:

* user `db`
* password `db`
* database `db`

---
**Contributed and maintained by [@bserem](https://github.com/bserem).**
