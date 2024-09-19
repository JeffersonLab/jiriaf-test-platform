#!/bin/bash

export APISERVER_PORT="38687" #35679

for i in $(seq 1 1)
do
    i_padded=$(printf "%02d" $i)
    # if i is 7, then rename i as "fs"
    if [ $i -eq 7 ]; then
        i="fs"
    fi
    ssh -NfR $APISERVER_PORT:localhost:$APISERVER_PORT fab-50
    ssh -NfL *:11990:localhost:11990 fab-50

    ssh -NfL *:42221:localhost:2221 fab-50
    ssh -NfL *:41776:localhost:1776 fab-50
    ssh -NfL *:48088:localhost:8088 fab-50
    ssh -NfL *:41990:localhost:1990 fab-50
    ssh -NfL *:42222:localhost:2222 fab-50


    scp -r $(dirname "$0")/node-setup.sh fab-50:~/

    # create .kube folder on fab-50
    ssh fab-50 "mkdir -p ~/.kube"
    # scp "$HOME/.kube/config" fab-50:~/.kube/config
    scp "$HOME/.kube/config" fab-50:~/.kube/config
    # run node-setup.sh on each node
    ssh fab-50 "./node-setup.sh"
    sleep 3
done
wait