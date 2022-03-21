setup() {
  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export TESTDIR=$(mktemp -d -t testadminer-XXXXXXXXXX)
  export PROJNAME=testadminer
  export DDEV_NON_INTERACTIVE=true
  ddev delete -Oy ${PROJNAME} || true
  cd "${TESTDIR}"
  ddev config --project-name=${PROJNAME}
  echo ${PROJNAME}
  ddev start
}

teardown() {
  cd ${TESTDIR}
  ddev delete -Oy ${PROJNAME} || true
  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

@test "basic installation" {
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  echo "# ddev get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get ${DIR}
  ddev restart
  # This would be a clearer test, but doesn't work
  # status=$(ddev describe | grep adminer | head -1 | awk '{print $4}')
  # [[ "${status}" = "OK" ]]
  ddev describe | grep adminer | head -1 | awk '{print $4}'
}
