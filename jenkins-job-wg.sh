#!/usr/bin/env bash
set -e

# Jenkins job watch dog
# Fede Diaz nordri@gmail.com
# November 2011

# Jenkins TOKEN is here
source credentials

[[ "$DEBUG" == "true" ]] && set -x

usage() { echo "Usage: $0 -u JENKINS_USER -j JENKINS_JOB -b JENKINS_BUILD" 1>&2; exit 1; }

# getting arguments
while getopts ":u:j:b:" option; do
    case "${option}" in
        u)
            JENKINS_USER=${OPTARG}
            ;;
        j)
            JENKINS_JOB=${OPTARG}
            ;;
        b)
            BUILD_NUMBER=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done

if [ -z "${JENKINS_USER}" ] || [ -z "${JENKINS_JOB}" ] || [ -z "${BUILD_NUMBER}" ]; then
    usage
fi

RES=$(curl -k --silent https://${JENKINS_USER}:${JENKINS_TOKEN}@jenkins-nxc-dev.intra.nexthink.com/job/Development/job/${JENKINS_JOB}/${BUILD_NUMBER}/api/json | jq -r '.result')

while [ "${RES}" == "null" ];
do
    sleep 5m
    RES=$(curl -k --silent https://${JENKINS_USER}:${JENKINS_TOKEN}@jenkins-nxc-dev.intra.nexthink.com/job/Development/job/${JENKINS_JOB}/${BUILD_NUMBER}/api/json | jq -r '.result')
done