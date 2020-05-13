#!/usr/bin/env bash


if [ -z "$1" ] || [ "$1" = '-h' ] || [ "$1" = '--help' ]
then
    fmt <<EOF

This script provides a way to execute commands in a container using one of the
Jutge images.

By default, the script runs the given commands in the container, after mounting
the current working directory as the worker user in the container. But, when \$1
is jutge-submit, the current directory is not mounted and all communication is
expected to be through pipes.

EOF
    exit
fi

for jutge_version in jutge-server jutge-full jutge-lite jutge-test
do
    ver="$(docker image ls | awk '{print $1}' | grep $jutge_version)"
    if [ "$ver" ]
    then
        selected_version="$ver"
        break
    fi
done

if [ -z "$selected_version" ]
then
    selected_version='jutgeorg/jutge-lite'
fi

if [ $1 == 'jutge-submit' ]
then
    docker run --rm -i $selected_version $@
elif [ $1 == 'bash' ]
then
    docker run --rm -it -v $(pwd):/home/worker $selected_version $@
else
    docker run --rm -t -v $(pwd):/home/worker $selected_version $@
fi
