#!/bin/bash
# run this on login04

export APISERVER_PORT="35679"

ssh -NfL $APISERVER_PORT:localhost:$APISERVER_PORT jiriaf2301