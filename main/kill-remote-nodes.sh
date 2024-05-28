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
    # kill remote process whose commands has "virtual-kubelet"
    ssh ejfat-$i "pkill -f virtual-kubelet" &
    sleep 3
done

wait