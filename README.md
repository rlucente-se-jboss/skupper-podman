# WIP
# How to configure skupper-podman
Configure a router node then one or more client nodes to establish links
with the router. This is an extremely simple two node configuration
but you can also have topologies that include relay nodes and more
complex meshes.

Install minimal RHEL 9.4 on various nodes that have network connections
in at least pairs, e.g. node 1 <--> node 2 <--> node 3 but not necessarily
a direct link between node 1 and node 3.

## Prepare each node
Edit `demo.conf` and make sure its correct.

    cd ~/skupper-podman
    sudo ./register-and-update.sh
    sudo reboot

    sudo ./install-si.sh

## On the router node

    cd ~/skupper-podman
    ./config-si-service.sh
    ./config-si-token.sh

Show the token file name.

    cd ~/skupper-podman
    . demo.conf
    cat $SI_TOKEN_FILE

## On all other client nodes
Make sure the `$SI_TOKEN_FILE` is on all other nodes with file permissions
`0600`. The values `someuser` and `somehost` should match the user and
DNS name/IP address of the relay node.

    . ~/skupper-podman/demo.conf
    scp someuser@somehost:$SI_TOKEN_FILE .

The `--ingress none` option means that this node does not accept
incoming connections but only connects to other nodes.

    cd ~/skupper-podman
    ./config-si-service.sh --ingress none
    ./config-si-link.sh

## Check that the links are active
Check the status of the links from all the nodes.

    cd ~/skupper-podman
    . demo.conf
    skupper link status
