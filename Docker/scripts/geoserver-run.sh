#!/bin/env bash

. ${0%/*}/plugin-loader.sh

function processConfigFile {
    for plugin in $(grep '[plugin]' ${1}); do
        plugins+=(${plugin##* })
    done
}

function activatePlugin {
    if [[ plugin-loader-isSupported ${1} ]]; then
        plugin-loader-load ${1}
    fi
}

function startGeoServer {
    tc_script=''
    tc_cmd='run'

    if [[ ${CATALINA_HOME} && -e ${CATALINA_HOME}/bin/catalina.sh ]]; then
        tc_script=${CATALINA_HOME}/bin/catalina.sh
    elif [[ -e /usr/lib/tomcat/bin/catalina.sh ]]; then
        tc_script=/usr/lib/tomcat/bin/catalina.sh
    elif [[ $(which catalina.sh 2>/dev/null) ]]; then
        tc_script=$(which catalina.sh 2>/dev/null)
    else
        echo >&2 "Unable to start GeoServer. Cannot find tomcat \"catalina.sh\" script."
        exit 2
    fi

    if [[ ${CATALINA_OPTS} ]]; then
        tc_cmd+=" ${CATALINA_OPTS}"
    fi

    "${tc_script}" ${tc_cmd}
}

config_file=''
plugins=()

while [[ ! -z ${1} ]]; do
    case ${1} in
        -p|--plugin)
            plugins+=(${2})
            shift
            ;;
        -f|--conf-file)
            config_file=${2}
            shift
            ;;
        *)
            echo >&2 "Unknown option provided: ${1}"
            exit 1
    esac
    shift
done

if [[ ${config_file} ]]; then
    processConfigFile ${config_file}
fi

for plugin in ${plugins[@]}; do
    activatePlugin ${plugin}
done

startGeoServer
