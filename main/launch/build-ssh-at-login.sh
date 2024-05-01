#!/bin/bash
# run this on login04

export APISERVER_PORT="35679"

ssh -NfL $APISERVER_PORT:localhost:$APISERVER_PORT jiriaf2301


export vk1="10001"
export ersap1="12221"
export process_exporter1="11776"
export ejfat1="18080"

ssh -NfR $vk1:localhost:$vk1 jiriaf2301
ssh -NfR $ersap1:localhost:$ersap1 jiriaf2301
ssh -NfR $process_exporter1:localhost:$process_exporter1 jiriaf2301
ssh -NfR $ejfat1:localhost:$ejfat1 jiiriaf2301



# export n2="10002"
# ssh -NfR $n2:localhost:$n2 jiriaf2301


