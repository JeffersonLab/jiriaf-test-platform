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
    ssh -NfR $APISERVER_PORT:localhost:$APISERVER_PORT ejfat-$i  
    # echo "100""$i_padded"
    # ssh -NfL *:100$i_padded:localhost:100$i_padded ejfat-$i
    # echo "200""$i_padded"
    # ssh -NfL *:200$i_padded:localhost:2221 ejfat-$i
    # echo "300""$i_padded"
    # ssh -NfL *:300$i_padded:localhost:1776 ejfat-$i
    # echo "400""$i_padded"
    # ssh -NfL *:400$i_padded:localhost:8088 ejfat-$i

    scp -r $HOME/JIRIAF/JIRIAF-test-platform/main/node-setup.sh ejfat-$i:~/
    # run node-setup.sh on each node
    ssh ejfat-$i "chmod +x node-setup.sh && ./node-setup.sh $i $(ping -c 1 ejfat-$i | awk -F'[()]' '/PING/{print $2}')" &
    sleep 3
done


wait