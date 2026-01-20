#!/usr/bin/env bats

# Bats is a testing framework for Bash
# Documentation https://bats-core.readthedocs.io/en/stable/
# Bats libraries documentation https://github.com/ztombol/bats-docs

# For local tests, install bats-core, bats-assert, bats-file, bats-support
# And run this in the add-on root directory:
#   bats ./tests/test.bats
# To exclude release tests:
#   bats ./tests/test.bats --filter-tags '!release'
# For debugging:
#   bats ./tests/test.bats --show-output-of-passing-tests --verbose-run --print-output-on-failure

setup() {
  set -eu -o pipefail

  # Override this variable for your add-on:
  export GITHUB_REPO=ddev/ddev-adminer

  TEST_BREW_PREFIX="$(brew --prefix 2>/dev/null || true)"
  export BATS_LIB_PATH="${BATS_LIB_PATH}:${TEST_BREW_PREFIX}/lib:/usr/lib/bats"
  bats_load_library bats-assert
  bats_load_library bats-file
  bats_load_library bats-support

  export DIR="$(cd "$(dirname "${BATS_TEST_FILENAME}")/.." >/dev/null 2>&1 && pwd)"
  export PROJNAME="test-$(basename "${GITHUB_REPO}")"
  mkdir -p ~/tmp
  export TESTDIR=$(mktemp -d ~/tmp/${PROJNAME}.XXXXXX)
  export DDEV_NONINTERACTIVE=true
  export DDEV_NO_INSTRUMENTATION=true
  ddev delete -Oy "${PROJNAME}" >/dev/null 2>&1 || true
  cd "${TESTDIR}"
  run ddev config --project-name="${PROJNAME}" --project-tld=ddev.site
  assert_success
  run ddev start -y
  assert_success

  export ADMINER_DESIGN=""
}

health_checks() {
  # Make sure we can hit the 9101 port successfully
  run curl -sfI https://${PROJNAME}.ddev.site:9101
  assert_success
  assert_output --partial "HTTP/2 302"
  assert_output --partial "location: ?server=db&username=db&db=db"

  # Make sure `ddev adminer` works
  DDEV_DEBUG=true run ddev adminer
  assert_success
  assert_output --partial "FULLURL https://${PROJNAME}.ddev.site:9101"

  if [ "${ADMINER_DESIGN}" != "" ]; then
    run ddev exec -s adminer 'echo $ADMINER_DESIGN'
    assert_output "${ADMINER_DESIGN}"

    run curl -sfI https://${PROJNAME}.ddev.site:9101/adminer.css
    assert_success
    assert_output --partial "HTTP/2 302"
    assert_output --partial "content-type: text/css"

    run curl -sfI https://${PROJNAME}.ddev.site:9101/adminer.css
    assert_success
    assert_output --partial "${ADMINER_DESIGN}"
  fi
}

teardown() {
  set -eu -o pipefail
  ddev delete -Oy "${PROJNAME}" >/dev/null 2>&1
  # Persist TESTDIR if running inside GitHub Actions. Useful for uploading test result artifacts
  # See example at https://github.com/ddev/github-action-add-on-test#preserving-artifacts
  if [ -n "${GITHUB_ENV:-}" ]; then
    [ -e "${GITHUB_ENV:-}" ] && echo "TESTDIR=${HOME}/tmp/${PROJNAME}" >> "${GITHUB_ENV}"
  else
    [ "${TESTDIR}" != "" ] && rm -rf "${TESTDIR}"
  fi
}

@test "install from directory" {
  set -eu -o pipefail
  echo "# ddev add-on get ${DIR} with project ${PROJNAME} in $(pwd)" >&3
  run ddev add-on get "${DIR}"
  assert_success
  run ddev restart -y
  assert_success
  health_checks
}

# bats test_tags=release
@test "install from release" {
  set -eu -o pipefail
  echo "# ddev add-on get ${GITHUB_REPO} with project ${PROJNAME} in $(pwd)" >&3
  run ddev add-on get "${GITHUB_REPO}"
  assert_success
  run ddev restart -y
  assert_success
  health_checks
}

@test "install from directory with nonstandard port and .env.adminer" {
  set -eu -o pipefail

  export ADMINER_DESIGN=dracula

  run ddev config --router-http-port=8080 --router-https-port=8443
  assert_success
  run ddev dotenv set .ddev/.env.adminer --adminer-design="${ADMINER_DESIGN}"
  assert_success
  assert_file_exist .ddev/.env.adminer
  echo "# ddev add-on get ${DIR} with project ${PROJNAME} in $(pwd)" >&3
  run ddev add-on get "${DIR}"
  assert_success
  run ddev restart -y
  assert_success
  health_checks
}
