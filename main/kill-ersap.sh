#!/bin/bash
for i in $(seq 2 7)
do
    i_padded=$(printf "%02d" $i)
    # if i is 7, then rename i as "fs"
    if [ $i -eq 7 ]; then
        i="fs"
    fi
    # kill Docker container with name "gurjyan/ersap:v0.1"
    ssh ejfat-$i "docker kill $(docker ps -q --filter ancestor=gurjyan/ersap:v0.1)" &
    sleep 3
done

wait