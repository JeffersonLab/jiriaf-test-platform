#!/bin/bash

alias psp="ps -u $USER -o pid,ppid,sid,pgid,%cpu,%mem,cmd"

psp | grep localhost