#!/bin/bash

# lil helper script to deploy all 3 blacklight apps

function usage() {
    echo
    echo "    Usage: $0 version prod|dev"
    echo
    echo "    e.g.   $0 2.0.10-rc2 prod"
    echo
    exit
}

if [ $# -ne 2 ]; then
    usage
fi

if ! grep -q " $2 " <<< " prod dev "; then
    usage
fi

YYYYMMDDHHMM=`date +%Y%m%d%H%M`

# update glimmer repo
cd ${HOME}/projects/glimmer
git checkout main
git pull -v

cd ${HOME}/projects

# redeploy all 3
glimmer/deploy.sh ${YYYYMMDDHHMM}.pahma pahma $2 $1
glimmer/deploy.sh ${YYYYMMDDHHMM}.cinefiles cinefiles $2 $1
glimmer/deploy.sh ${YYYYMMDDHHMM}.bampfa bampfa $2 $1
