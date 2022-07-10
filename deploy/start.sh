#!/bin/bash
echo "boot start"
# start.sh ${APP_PROFILE} ${APP_PORT} ${DEPLOY_TAG} ${DIST_DIR}

APP_PROFILE=$1
APP_PORT=$2
DEPLOY_TAG=$3
DIST_DIR=$4


function __help(){
    echo "usage: $0 <profile> <port> <deploy_tag> <DIST_DIR>"
    echo "e.g. $0 test 8080 v20220707 ../dist"
    exit
}

if [[ $# != 4 ]]; then
    __help
fi


echo "run app"

cd "${DIST_DIR}" || exit

echo "clean .venv"
rm -rf .venv

echo "setup .venv"
python3 -m venv .venv

echo "install requirements"
.venv/bin/pip install -i https://mirrors.aliyun.com/pypi/simple/ -r requirements.txt

echo "start app"
.venv/bin/python start.py ${APP_PORT}

echo "done"