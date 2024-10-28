setup() {
  set -eu -o pipefail
  brew_prefix=$(brew --prefix)
  load "${brew_prefix}/lib/bats-support/load.bash"
  load "${brew_prefix}/lib/bats-assert/load.bash"

  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export TESTDIR=~/tmp/test-adminer
  mkdir -p $TESTDIR
  export PROJNAME=test-adminer
  export DDEV_NON_INTERACTIVE=true
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true
  cd "${TESTDIR}"
  ddev config --project-name=${PROJNAME}
  ddev start -y >/dev/null 2>&1
}

health_checks() {
  set +u # bats-assert has unset variables so turn off unset check
  # ddev restart is required because we have done `ddev add-on get` on a new service
  run ddev restart
  assert_success
  # Make sure we can hit the 9101 port successfully
  curl -s -I -f https://${PROJNAME}.ddev.site:9101 >/tmp/curlout.txt
  # Make sure `ddev adminer` works
  DDEV_DEBUG=true run ddev adminer
  assert_success
  assert_output --partial "FULLURL https://${PROJNAME}.ddev.site:9101"
}

teardown() {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1
  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

@test "install from directory" {
  set -eu -o pipefail
  cd ${TESTDIR}
  echo "# ddev add-on get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev add-on get ${DIR} >/dev/null 2>&1
  ddev mutagen sync >/dev/null 2>&1
  health_checks
}

@test "install from release" {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  echo "# ddev add-on get ddev/ddev-adminer with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev add-on get ddev/ddev-adminer >/dev/null 2>&1
  ddev restart >/dev/null 2>&1
  health_checks
}

@test "install from directory with nonstandard port" {
  set -eu -o pipefail
  cd ${TESTDIR}
  ddev config --router-http-port=8080 --router-https-port=8443
  echo "# ddev add-on get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev add-on get ${DIR} >/dev/null 2>&1
  ddev mutagen sync >/dev/null 2>&1
  health_checks
}
