[![add-on registry](https://img.shields.io/badge/DDEV-Add--on_Registry-blue)](https://addons.ddev.com)
[![tests](https://github.com/ddev/ddev-adminer/actions/workflows/tests.yml/badge.svg?branch=main)](https://github.com/ddev/ddev-adminer/actions/workflows/tests.yml?query=branch%3Amain)
[![last commit](https://img.shields.io/github/last-commit/ddev/ddev-adminer)](https://github.com/ddev/ddev-adminer/commits)
[![release](https://img.shields.io/github/v/release/ddev/ddev-adminer)](https://github.com/ddev/ddev-adminer/releases/latest)

# DDEV Adminer

## Overview

[Adminer](https://www.adminer.org/) is a full-featured database management tool written in PHP.

This add-on integrates Adminer into your [DDEV](https://ddev.com/) project.

Adminer works with MySQL, MariaDB, PostgreSQL, SQLite, MS SQL, Oracle, and MongoDB.

## Installation

```bash
ddev add-on get ddev/ddev-adminer
ddev restart
```

After installation, make sure to commit the `.ddev` directory to version control.

## Usage

| Command | Description |
| ------- | ----------- |
| `ddev adminer` | Open Adminer in your browser (`https://<project>.ddev.site:9101`) |
| `ddev describe` | View service status and used ports for Adminer |
| `ddev logs -s adminer` | Check Adminer logs |

## Advanced Customization

To change the design:

```bash
# design: https://www.adminer.org/en/#extras
ddev dotenv set .ddev/.env.adminer --adminer-design=dracula
ddev add-on get ddev/ddev-adminer
ddev restart
```

Make sure to commit the `.ddev/.env.adminer` file to version control.

To add more plugins:

```bash
# plugins: https://www.adminer.org/en/plugins/
ddev dotenv set .ddev/.env.adminer --adminer-plugins="tables-filter edit-calendar"
ddev add-on get ddev/ddev-adminer
ddev restart
```

If a plugin *requires* parameters, refer to the [official documentation](https://hub.docker.com/_/adminer) for more details.

Make sure to commit the `.ddev/.env.adminer` file to version control.

All customization options (use with caution):

| Variable | Flag | Default |
| -------- | ---- | ------- |
| `ADMINER_DEFAULT_DB` | `--adminer-default-db` | `db` |
| `ADMINER_DEFAULT_DRIVER` | `--adminer-default-driver` | `server` |
| `ADMINER_DEFAULT_PASSWORD` | `--adminer-default-password` | `db` |
| `ADMINER_DEFAULT_USERNAME` | `--adminer-default-username` | `db` |
| `ADMINER_DESIGN` | `--adminer-design` | `` |
| `ADMINER_DOCKER_IMAGE` | `--adminer-docker-image` | `adminer:standalone` |
| `ADMINER_PLUGINS` | `--adminer-plugins` | `tables-filter` |

## Credits

**Contributed by [@bserem](https://github.com/bserem)**

**Maintained by the [DDEV team](https://ddev.com/support-ddev/)**
