#!/bin/bash
# run this on login04

# export APISERVER_PORT="35679"

# ssh -NfL $APISERVER_PORT:localhost:$APISERVER_PORT jiriaf2301


# run this on jiriaf2301 to login04 at nersc
ssh -i ~/.ssh/nersc -J perlmutter -NfR :35679:localhost:35679 jlabtsai@128.55.64.13