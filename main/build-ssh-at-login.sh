#!/bin/bash
# run this on login04

# export APISERVER_PORT="35679"

# ssh -NfL $APISERVER_PORT:localhost:$APISERVER_PORT jiriaf2301

for i in $(seq 2 7)
do
    i_padded=$(printf "%02d" $i)
    # if i is 7, then rename i as "fs"
    if [ $i -eq 7 ]; then
        i="fs"
    fi
    ssh -NfR $APISERVER_PORT:localhost:$APISERVER_PORT ejfat-$i  
    echo "100""$i_padded"
    ssh -NfL 100$i_padded:localhost:100$i_padded ejfat-$i
    echo "200""$i_padded"
    ssh -NfL 200$i_padded:localhost:200$i_padded ejfat-$i
    echo "300""$i_padded"
    ssh -NfL 300$i_padded:localhost:300$i_padded ejfat-$i
    echo "400""$i_padded"
    ssh -NfL 400$i_padded:localhost:400$i_padded ejfat-$i
done


wait