setup() {
  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export TESTDIR=$(mktemp -d -t testadminer-XXXXXXXXXX)
  export PROJNAME=testadminer
  export DDEV_NON_INTERACTIVE=true
  ddev delete -Oy ${PROJNAME} || true
  cd "${TESTDIR}"
  ddev config --project-name=${PROJNAME} --project-type=drupal9 --docroot=web --create-docroot
  ddev start
}

teardown() {
  cd ${TESTDIR}
  ddev delete -Oy ${DDEV_SITENAME}
  rm -rf ${TESTDIR}
}

@test "basic installation" {
  cd ${TESTDIR}
  ddev get ${DIR}
  ddev restart
  status=$(ddev describe | grep adminer | head -1 | awk '{print $4}')
  [ "${status}" = "ok" ]
}
