#!/bin/env bash

sp_file=${0%/*}/supported-plugins.txt

if [[ -z ${GEOSERVER_SRC} ]]; do
    echo >&2 "Cannot load plugins. GEOSERVER_SRC is unset, so they cannot be found."
fi

tc_home=${CATALINA_HOME}

if [[ -z ${tc_home} ]]; then
    echo >&2 "CATALINA_HOME is unset; falling back to /var/lib/tomcat"

    if [[ -d /var/lib/tomcat ]]; then
        tc_home=/var/lib/tomcat
    else
        echo >&2 "/var/lib/tomcat doesn't exist. Can't install plugins."
        exit 3
    fi
else

install_dir=webapps/geoserver/WEB-INF/lib/

if [[ ! -d ${tc_home}/${install_dir} ]]; then
    echo >&2 "${tc_home}/${install_dir} cannot be found. Can't install plugins."
    exit 4
fi

GEOSERVER_PLUGIN_DIR=${tc_home}/${install_dir}

unset $install_dir
unset $tc_home

function plugin-loader-isSupported {
    if $(grep "${1}:" "${sp_file}"); then
        echo 1
    fi
}

function plugin-loader-load {
    plugin_config=$(grep "${1}:" "${sp_file}")
    settings=$(echo ${plugin_config#*:} | sed 's/|/ /g')

    yum_settings=()
    lib_settings=()

    for component in ${settings[@]}; do
        if [[ ${component} =~ yum=(.+) ]]; then
            yum_settings=($(echo ${component#*=} | sed 's/,/ /g'))
        elif [[ ${component} =~ lib=(.+) ]]; then
            lib_settings=($(echo ${component#*=} | sed 's/,/ /g'))
        else
            echo >&2 "Unknown component in settings ${component}"
        fi
    done

    yum install -y -q ${yum_settings[@]}

    for l in ${lib_settings[@]}; do
        cp -v ${GEOSERVER_SRC}/{extensions,community}/${l} ${GEOSERVER_PLUGIN_DIR}
    done
}
