[![tests](https://github.com/bserem/ddev-adminer/actions/workflows/tests.yml/badge.svg)](https://github.com/bserem/ddev-adminer/actions/workflows/tests.yml) ![project is maintained](https://img.shields.io/maintenance/yes/2022.svg)

# DDEV Adminer Service

## What is this?

This repository allows you to quickly install Adminer database manager into a [Ddev](https://ddev.readthedocs.io) project using just `ddev get bserem/ddev-adminer`.

Adminer (formerly phpMinAdmin) is a full-featured database management tool written in PHP. **Adminer is available for MySQL, MariaDB, PostgreSQL, SQLite, MS SQL, Oracle, Elasticsearch, MongoDB, SimpleDB ([plugin](https://raw.githubusercontent.com/vrana/adminer/master/plugins/drivers/simpledb.php)), Firebird ([plugin](https://raw.githubusercontent.com/vrana/adminer/master/plugins/drivers/firebird.php)), ClickHouse ([plugin](https://raw.githubusercontent.com/vrana/adminer/master/plugins/drivers/clickhouse.php)).**

This service currently ships the default adminer package with no external plugins.

## Installation

* `ddev get drud/ddev-memcached && ddev restart`

## Caveats
* You need to pass database credentials manually for the time being. If you have any ideas on how to overcome this issue please let me know. **Default ddev database credentials are: user `db`, pass `db`, database `db`.**

**Contributed and maintained by [@bserem](https://github.com/bserem).**
