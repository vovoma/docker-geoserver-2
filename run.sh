#!/bin/env bash

CONTAINER_HOME=$(cd $(dirname ${0}); pwd)

mounts=("-v ${CONTAINER_HOME}/data:/var/lib/geoserver/data" "-v ${CONTAINER_HOME}/logs:/var/log/tomcat")

options=('-d')

tag='2.7'

args=()

while [[ ${1} ]]; do
    case ${1} in
        -v)
            shift
            mounts+=("-v ${1}")
            ;;
        -i)
            options=('-it')
            mounts+=('-v ~/.bash_history:/root/.bash_history')
            args=('/bin/bash')
            ;;
        -t)
            shift
            tag=${1}
            ;;
        -*)
            echo >2 'Unkown option provided: ${1}'
            exit 1
            ;;
        *)
            args+=(${1})
    esac
    shift
done

pushd ${DOCKER_BUILD_LOCATION} 2>/dev/null

docker run ${mounts[@]} ${options[@]} briandlee/geoserver@${tag} ${args}

popd 2>/dev/null
