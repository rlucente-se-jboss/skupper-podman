#!/usr/bin/env bash

. $(dirname $0)/demo.conf

[[ $EUID -ne 0 ]] && exit_on_error "Must run as root"

subscription-manager repos --enable=$SI_REPO
dnf -y install skupper-cli container-tools

firewall-cmd --permanent --add-port=45671/tcp --add-port=55671/tcp
firewall-cmd --reload
