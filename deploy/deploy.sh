#!/bin/bash

# 项目启动脚本

function __help(){
    echo "usage: $0 <app_name> <profile> <port> <deploy_tag> <dist_dir>"
    echo "e.g. $0 nvwa-api test 8080 v20220707 ./dist"
    exit
}

if [[ $# != 5 ]]; then
    __help
fi

# args
DEPLOY_SCRIPT=$0

APP_NAME=$1

APP_PROFILE=$2

APP_PORT=$3

DEPLOY_TAG=$4

TARGET_DIR=$5

# tools
SUPERVISORCTL=supervisorctl

# options

APP_PROFILES="test production"

# dirs
HOME_DIR=/data
APPS_HOME_DIR=${HOME_DIR}/apps
LOGS_HOME_DIR=${HOME_DIR}/logs
DEPLOY_DIR=$(dirname "${DEPLOY_SCRIPT}")
APP=${APP_NAME}-${APP_PROFILE}-${APP_PORT}
LOG_DIR=${LOGS_HOME_DIR}/${APP}
APP_DIR=${APPS_HOME_DIR}/${APP}
DIST_DIR=${APPS_HOME_DIR}/${APP}/dist
SUPERVISOR_DIR=${APPS_HOME_DIR}/${APP}/supervisor

CONF_FILE=${SUPERVISOR_DIR}/supervisor.conf

function __checkProfile(){
   for PROFILE_OPTION in ${APP_PROFILES}
   do
      if [ "${PROFILE_OPTION}" == "${APP_PROFILE}" ]; then
         return
      fi
   done
   echo "No profile found with: ${APP_PROFILE} in ${APP_PROFILES}"
   __help
}

__checkProfile

function __deploy(){
    echo "0. stop service"

    num=`${SUPERVISORCTL} status | grep ${APP} | grep RUNNING | wc -l`
    if [ ${num} -gt 0 ]; then
        echo "stop supervisor process: ${APP}"
        ${SUPERVISORCTL} stop ${APP}
    else
        echo "supervisor process is not running"
    fi


    echo "1. make LOG_DIR at ${LOG_DIR}"
    mkdir -p ${LOG_DIR}

    echo "2. rm APP_DIR at ${APP_DIR}"
    rm -rf ${APP_DIR}

    echo "3. make APP_DIR at ${APP_DIR}"
    mkdir -p ${APP_DIR}

    echo '4. copy start.sh '
    cp  ${DEPLOY_DIR}/start.sh ${APP_DIR}/
    chmod +x ${APP_DIR}/start.sh

    echo "5.set up SUPERVISORCTL config ${APP} at ${CONF_FILE}"
    mkdir -p ${SUPERVISOR_DIR}
    {
      echo "[program:${APP}]"
      echo "stopasgroup=true"
      echo "autorestart=true"
      echo "user=${USER}"
      echo "stdout_logfile=${LOG_DIR}/stdout.log"
      echo "stderr_logfile=${LOG_DIR}/stderr.log"
      echo "command=${APP_DIR}/start.sh ${APP_PROFILE} ${APP_PORT} ${DEPLOY_TAG}  ${DIST_DIR}"
    } > "${CONF_FILE}"

    echo 'config content: '
    cat ${CONF_FILE}

    echo "7. make DIST_DIR at ${DIST_DIR}"
    mkdir -p ${DIST_DIR}

    echo '8. copy new app'
    cp -r ${TARGET_DIR}/* ${DIST_DIR}/

    echo "9. update supervisorctl"
    ${SUPERVISORCTL} update

    echo '10. start...'
    ${SUPERVISORCTL} start ${APP}
}

__deploy
