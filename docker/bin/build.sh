#! /bin/sh

set -e

cd /usr/src/workspace

. ./.env.sh

eval $(opam config --switch ${OPAMSWITCH:-${DEFAULT_OPAMSWITCH}} --root $OPAMROOT env)

git clean -dxf

set -x

. ./.jenkins.sh

if [ ! -z "${JENKINS_BUILD_DOC}" ]; then

  cd /usr/src

  git clone https://github.com/ocsigen/wikidoc
  git clone https://github.com/ocsigen/ocsigen.org-data

  opam pin add wikidoc wikidoc

  TARGET_DIR=/usr/src/ocsigen.org-data/${JENKINS_BUILD_DOC}/dev
  API_DIR=${TARGET_DIR}/api
  MANUAL_SRC_DIR=${TARGET_DIR}/manual/src
  MANUAL_FILES_DIR=${TARGET_DIR}/manual/files

  cd /usr/src/ocsigen.org-data
  git rm -rf ${JENKINS_BUILD_DOC}/dev
  mkdir -p ${API_DIR}
  mkdir -p ${MANUAL_SRC_DIR}
  mkdir -p ${MANUAL_FILES_DIR}

  cd ${OPAMROOT}/${OPAMSWITCH:-${DEFAULT_OPAMSWITCH}}/build/${JENKINS_BUILD_DOC}.dev

  do_build_doc

  if [ ! -z "${JENKINS_COMMIT_DOC}" ]; then

    cd /usr/src/ocsigen.org-data

    git add ${JENKINS_BUILD_DOC}/dev

    if git commit -m `git log -n 1 --format=${JENKINS_BUILD_DOC}-%h`; then
      git pull
      git push 'git@github.com:ocsigen/ocsigen.org-data'
    fi

  fi

fi

do_remove
