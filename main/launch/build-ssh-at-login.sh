#!/bin/bash
# run this on login04

export APISERVER_PORT="35679"

ssh -NfL $APISERVER_PORT:localhost:$APISERVER_PORT jiriaf2301


# export vk1="10001"
# export ersap1="12221"
# export process_exporter1="11776"
# export ejfat1="18080"

# ssh -NfR $vk1:localhost:$vk1 jiriaf2301
# ssh -NfR $ersap1:localhost:$ersap1 jiriaf2301
# ssh -NfR $process_exporter1:localhost:$process_exporter1 jiriaf2301
# ssh -NfR $ejfat1:localhost:$ejfat1 jiriaf2301

for i in $(seq 1 2)
do
  export vk$i="1000$i"
  export ersap$i="$i""2221"
  export process_exporter$i="$i""1776"
  export ejfat$i="$i""8080"

  ssh -NfR $vk$i:localhost:$vk$i jiriaf2301
  ssh -NfR $ersap$i:localhost:$ersap$i jiriaf2301
  ssh -NfR $process_exporter$i:localhost:$process_exporter$i jiriaf2301
  ssh -NfR $ejfat$i:localhost:$ejfat$i jiriaf2301

done