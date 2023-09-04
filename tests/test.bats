setup() {
  mkcert -install >/dev/null
  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export TESTDIR=$(mktemp -d -t testadminer-XXXXXXXXXX)
  export PROJNAME=testadminer
  export DDEV_NON_INTERACTIVE=true
  ddev delete -Oy ${PROJNAME} >/dev/null || true
  cd "${TESTDIR}"
  ddev config --project-name=${PROJNAME}
  echo ${PROJNAME}
  ddev start -y >/dev/null
}

teardown() {
  cd ${TESTDIR}
  ddev delete -Oy ${PROJNAME} || true
  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

@test "basic installation" {
  set -o pipefail
  cd ${TESTDIR} || ( printf "# unable to cd to ${TESTDIR}\n" >&3 && false )
  echo "# ddev get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get ${DIR}
  (ddev restart >/dev/null || (echo "# ddev restart returned exit code=%?" >&3 && false))
  ddev help adminer | grep adminer >/dev/null

  # ddev launcha must return an error
  (exit_status=0; (ddev launcha > /dev/null 2>&1) || exit_status=$?; echo $exit_status) | {
      read exit_status
      if [ $exit_status -eq 0 ]; then
          echo "Test failed: ddev launcha exited with no error"
          exit 2
      fi
  }

#  echo "# Trying curl -s -L -k https://${PROJNAME}.ddev.site:9101/" >&3
  curl --fail -s -L -k https://${PROJNAME}.ddev.site:9101/ | grep 'document.querySelector.*auth.*db' >/dev/null
}
