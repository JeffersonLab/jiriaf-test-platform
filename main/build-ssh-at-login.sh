#!/bin/bash
# run this on login04

# export APISERVER_PORT="35679"

# ssh -NfL $APISERVER_PORT:localhost:$APISERVER_PORT jiriaf2301


# run this on jiriaf2301 to login04 at nersc
export APISERVER_PORT="38687" #"35679"
ssh -i ~/.ssh/nersc -J perlmutter -NfR $APISERVER_PORT:localhost:$APISERVER_PORT ejfat



for i in $(seq 2 6)
do
    echo "100""$i_padded"
    ssh -i ~/.ssh/nersc -J perlmutter -NfL 100$i_padded:localhost:100$i_padded ejfat-$i_padded
    echo "200""$i_padded"
    ssh -i ~/.ssh/nersc -J perlmutter -NfL 200$i_padded:localhost:200$i_padded ejfat-$i_padded
    echo "300""$i_padded"
    ssh -i ~/.ssh/nersc -J perlmutter -NfL 300$i_padded:localhost:300$i_padded ejfat-$i_padded
    echo "400""$i_padded"
    ssh -i ~/.ssh/nersc -J perlmutter -NfL 400$i_padded:localhost:400$i_padded ejfat-$i_padded
done

wait