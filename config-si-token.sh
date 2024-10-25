#!/usr/bin/env bash

. $(dirname $0)/demo.conf

[[ $EUID -eq 0 ]] && exit_on_error "Must NOT run as root"

# Generate a token on only one site and share the file with all of the
# other sites

touch $SI_TOKEN_FILE
chmod 0600 $SI_TOKEN_FILE

skupper token create --ingress-host $HOSTIP $SI_TOKEN_FILE
