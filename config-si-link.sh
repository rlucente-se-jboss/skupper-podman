#!/usr/bin/env bash

. $(dirname $0)/demo.conf

[[ $EUID -eq 0 ]] && exit_on_error "Must NOT run as root"
[[ ! -f $SI_TOKEN_FILE ]] && exit_on_error "$SI_TOKEN_FILE is missing"
stat -c "%04a" $SI_TOKEN_FILE | grep -q '0600' || \
    exit_on_error "$SI_TOKEN_FILE permissions not 0600"

skupper link create $SI_TOKEN_FILE
skupper link status
