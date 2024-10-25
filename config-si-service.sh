#!/usr/bin/env bash

##
## pass the argument '--ingress none' if you don't want to allow incoming
## connections to this instance
##

. $(dirname $0)/demo.conf

[[ $EUID -eq 0 ]] && exit_on_error "Must NOT run as root"

systemctl --user enable --now podman.socket
loginctl enable-linger $USER

# login to the registry to pull the service connect container image
podman login --username $SCA_USER --password $SCA_PASS registry.redhat.io

# Skupper enables ingress on all network devices by default. This can
# be restricted (even to "none") if needed.
skupper init $@
