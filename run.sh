#!/bin/env bash

function help {
    echo "run.sh [options] [args]"
    echo "    -dp Destination port to map to (default: 8080)"
    echo "    -h  Display this help dialog"
    echo "    -i  Interactive mode, overrides default behavior to daemonize"
    echo "    -sp Source port to map (default: 80)"
    echo "    -t  Specifies tag for briandlee/geoserver image"
    echo "    -v  Mount volume, see docker documentation on \`docker run\`'s -v option"
    exit ${1}
}

CONTAINER_HOME=$(cd $(dirname ${0}); pwd | sed 's/ /\\ /')

mounts=("-v ${CONTAINER_HOME}/data:/var/lib/geoserver/data" "-v ${CONTAINER_HOME}/logs:/var/log/tomcat")
destport='8080'
tag='latest'
srcport='80'
runtype='-d'
args=()

while [[ ${1} ]]; do
    case ${1} in
        -h)
            help 0
            ;;
        -i)
            runtype='-it'
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
        -dp)
            shift
            destport=${1}
            ;;
        -sp)
            shift
            srcport=${1}
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

eval "docker run ${mounts[@]} -p ${srcport}:${destport} ${runtype} briandlee/geoserver@${tag} ${args}"

popd 2>/dev/null
