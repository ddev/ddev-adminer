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
  ddev help launcha | grep adminer >/dev/null
#  echo "# Trying curl -s -L -k https://${PROJNAME}.ddev.site:9101/" >&3
  curl --fail -s -L -k https://${PROJNAME}.ddev.site:9101/ | grep 'document.querySelector.*auth.*db' >/dev/null
}
