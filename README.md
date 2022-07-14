[![tests](https://github.com/drud/ddev-adminer/actions/workflows/tests.yml/badge.svg)](https://github.com/drud/ddev-adminer/actions/workflows/tests.yml) ![project is maintained](https://img.shields.io/maintenance/yes/2022.svg)

# DDEV Adminer Service

## What is this?

This repository allows you to quickly install Adminer database manager into a [Ddev](https://ddev.readthedocs.io) project using just `ddev get drud/ddev-adminer`.

Adminer is a full-featured database management tool written in PHP. This service
currently ships the [official adminer container](https://hub.docker.com/_/adminer)
with no _external_ plugins. It contains all official plugins and themes and allows
to easily chose one by editing the `docker-compose.adminer.yaml` file after
installation.

This currently supports:

* MySQL / MariaDB
* PostgreSQL

## Installation

* `ddev get drud/ddev-adminer && ddev restart`

Then you can just `ddev launch -a` or use `ddev describe` to get the URL (`https://<project>.ddev.site:9101`).

## What does this add-on do?

* Adds the adminer container as a service
* Overrides the `ddev launch` command at the project level with a `ddev launch -a` (or `ddev launch --adminer`) option.

**Contributed by [@bserem](https://github.com/bserem).**
**Maintained by DDEV team.**
