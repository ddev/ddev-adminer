[![tests](https://github.com/ddev/ddev-adminer/actions/workflows/tests.yml/badge.svg)](https://github.com/ddev/ddev-adminer/actions/workflows/tests.yml) ![project is maintained](https://img.shields.io/maintenance/yes/2025.svg)

# DDEV Adminer Service

## What is this?

This repository allows you to quickly install the [Adminer](https://www.adminer.org/) database manager into a [DDEV](https://ddev.readthedocs.io) project using just `ddev add-on get ddev/ddev-adminer`.

Adminer is a full-featured database management tool written in PHP. This service currently ships the [official adminer container](https://hub.docker.com/_/adminer) with no _external_ plugins.

Adminer works with MySQL, MariaDB, PostgreSQL, SQLite, MS SQL, Oracle, and MongoDB.

## Installation

```sh
ddev add-on get ddev/ddev-adminer && ddev restart
```

Then you can just `ddev adminer` or use `ddev describe` to get the URL (`https://<project>.ddev.site:9101`).

To customize Adminer setup:

```sh
# drivers: server, sqlite, sqlite2, pgsql, oracle, mssql, mongo, and more via plugins
# plugins: https://www.adminer.org/en/plugins/
# design: https://www.adminer.org/en/#extras
ddev dotenv set .ddev/.env.adminer \
    --adminer-docker-image="adminer:standalone" \
    --adminer-default-driver=server \
    --adminer-default-db=db \
    --adminer-default-username=db \
    --adminer-default-password=db \
    --adminer-plugins="tables-filter edit-calendar" \
    --adminer-design=dracula
git add .ddev/.env.adminer
ddev add-on get ddev/ddev-adminer && ddev restart
```

## What does this add-on do?

* Adds the adminer container as a service

**Contributed by [@bserem](https://github.com/bserem).**
**Maintained by DDEV team.**
