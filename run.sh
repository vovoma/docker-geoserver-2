#!/bin/env bash

function help {
    echo "run.sh [options] [args]"
    echo "    -h Display this help dialog"
    echo "    -i Interactive mode, boots into shell of container (may conflict with args if supplied)"
    echo "    -t Specifies tag for briandlee/geoserver image"
    echo "    -v Mount volume, see docker documentation on \`docker run\`'s -v option"
    exit ${1}
}

CONTAINER_HOME=$(cd $(dirname ${0}); pwd | sed 's/ /\\ /')

mounts=("-v ${CONTAINER_HOME}/data:/var/lib/geoserver/data" "-v ${CONTAINER_HOME}/logs:/var/log/tomcat")
options=('-p 80:8080 -d')
tag='2.7'
args=()

while [[ ${1} ]]; do
    case ${1} in
        -h)
            help 0
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
        -v)
            shift
            mounts+=("-v ${1// /\\ }")
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

eval "docker run ${mounts[@]} ${options[@]} briandlee/geoserver@${tag} ${args}"

popd 2>/dev/null
