#!/bin/bash

export APISERVER_PORT="38687" #35679

for i in $(seq 0 0)
do
    node_name="fab-5$i"
    echo "Launching node $node_name"
    ssh -NfR $APISERVER_PORT:localhost:$APISERVER_PORT $node_name
    ssh -NfL *:$((11000 + $i)):localhost:$((11000 + $i)) $node_name 
    ssh -NfL *:$((21000 + $i)):localhost:2221 $node_name
    ssh -NfL *:$((31000 + $i)):localhost:1776 $node_name
    ssh -NfL *:$((41000 + $i)):localhost:8088 $node_name
    ssh -NfL *:$((51000 + $i)):localhost:2222 $node_name


    scp -r $(dirname "$0")/node-setup.sh $node_name:~/

    # create .kube folder on fab-50
    ssh $node_name "mkdir -p ~/.kube"
    # scp "$HOME/.kube/config" fab-50:~/.kube/config
    scp "$HOME/.kube/config" $node_name:~/.kube/config
    # run node-setup.sh on each node
    ssh $node_name "./node-setup.sh $i" &
    sleep 3
done
wait