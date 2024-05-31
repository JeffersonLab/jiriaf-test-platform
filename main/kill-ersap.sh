#!/bin/bash
# run this on login04

export APISERVER_PORT="38687" #35679

for i in $(seq 2 7)
do
    i_padded=$(printf "%02d" $i)
    # if i is 7, then rename i as "fs"
    if [ $i -eq 7 ]; then
        i="fs"
    fi
    # kill remote Docker container with the name "gurjyan/ersap:v0.1"
    ssh ejfat-$i "docker kill \$(docker ps -q --filter ancestor=gurjyan/ersap:v0.1)" &
    sleep 3
done

wait