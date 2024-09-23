#!/bin/bash

export APISERVER_PORT="38687" #35679

for i in $(seq 1 2)
do
    node_name="fab-5$i"
    echo "Launching node $node_name"
    ssh -NfR $APISERVER_PORT:localhost:$APISERVER_PORT $node_name
    ssh -NfL *:$((10000 + $i)):localhost:$((10000 + $i)) $node_name 
    ssh -NfL *:$((20000 + $i)):localhost:2221 $node_name
    ssh -NfL *:$((30000 + $i)):localhost:1776 $node_name
    ssh -NfL *:$((40000 + $i)):localhost:8088 $node_name
    ssh -NfL *:$((50000 + $i)):localhost:2222 $node_name


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