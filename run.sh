
#!/bin/env bash

function help {
    echo "run.sh [options] [args]"
    echo "    -dp Destination port to map to (default: 8080)"
    echo "    -h  Display this help dialog"
    echo "    -i  Interactive mode, overrides default behavior to daemonize"
    echo "    -s  Boot into interactive shell (implies interactive mode '-i')"
    echo "    -sp Source port to map (default: 80)"
    echo "    -t  Specifies tag for briandlee/geoserver image"
    echo "    -v  Mount volume, see docker documentation on \`docker run\`'s -v option"
    exit ${1}
}

CONTAINER_HOME=$(cd $(dirname ${0}); pwd | sed 's/ /\\ /')

mounts=("-v ${CONTAINER_HOME}/data:/var/lib/geoserver/data" "-v ${CONTAINER_HOME}/logs:/var/log/tomcat")
entrypoint=0
destport='8080'
tag='2.7'
srcport='80'
runtype='-d'
args=()

while [[ ${1} ]]; do
    case ${1} in
        -h)
            help 0
            ;;
        -s)
            entrypoint="/bin/bash"
            runtype='-it'
            mounts+=('-v ~/.bash_history:/root/.bash_history')
            ;;
        -i)
            runtype='-it'
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
            echo >&2 'Unkown option provided: ${1}'
            exit 1
            ;;
        *)
            args+=(${1})
    esac
    shift
done

pushd ${DOCKER_BUILD_LOCATION} 2>/dev/null

entrypoint_opt=""

if [[ ${entrypoint} != 0 ]]; then
    entrypoint_opt="--entrypoint=${entrypoint}"
fi

cmd="docker run ${entrypoint_opt} -p ${srcport}:${destport} ${runtype} briandlee/geoserver@${tag} ${args[@]}"

echo "${cmd}"
eval "${cmd}"

popd 2>/dev/null
