# WIP
# Red Hat Service Interconnect with Podman
This repository establishes a Service Interconnect simple two node network
using skupper-podman. We configure a router node then one client node
to establish a link with the router. This is an extremely simple two
node configuration but you can also have topologies that include relay
nodes and more complex meshes.

## Prepare each host in the network
Start with a minimal install of RHEL 9.4 either on baremetal or on
a guest VM. Use UEFI firmware, if able to, when installing the host
system. Also make sure there's sufficient disk space on each host to
support the demo. I typically configure a 64 GiB disk on the host.

Make sure to enable FIPS mode during installation, so that configuring
keys for the Service Interconnect network are using validated
cryptographic libraries. To do that, select `Install Red Hat Enterprise
Linux 9.4` on first boot within the GRUB boot menu and then press `e`
to edit the boot commandline. Add `fips=1` to the end of the line that
begins with `linuxefi` and then press CTRL-X to continue booting.

During RHEL installation, configure a regular user with `sudo` privileges
on the host.

These instructions assume that this repository is cloned or copied to
your user's home directory on each host (e.g. `~/skupper-podman`). The
below instructions follow that assumption.

Edit the `demo.conf` file and make sure the settings are correct. At a
minimum, you should adjust the credentials for simple content access.
The full list of options in the `demo.conf` file are shown here.

#### Red Hat Simple Content Access
| Parameter | Description |
| --------- | ----------- |
| SCA_USER  | Your username |
| SCA_PASS  | Your password |

#### Skupper Configuration
| Parameter        | Description |
| ---------------- | ----------- |
| SI_REPO          | The repository from which to install the skupper packages |
| SKUPPER_PLATFORM | This can be either `podman` or `kubernetes` |
| SI_TOKEN_FILE    | Token with mTLS keys to connect to the router node |
| HOSTIP           | The routable IP address of this host |

Run the following commands to register and update the system.

    cd ~/skupper-podman
    sudo ./register-and-update.sh
    sudo reboot

Install the Service Interconnect packages and container tooling.

    sudo ./install-si.sh

## On the router node
Configure the router node which will accept incoming connections. Service
Interconnect effects two-way communitcations between nodes on its network,
but only one node needs to initiate a link to another node.

    cd ~/skupper-podman
    ./config-si-service.sh

Generate the secure token to enable client nodes to connect to the
router node.

    cd ~/skupper-podman
    ./config-si-token.sh

Review the token file contents.

    cd ~/skupper-podman
    . demo.conf
    cat $SI_TOKEN_FILE

## On all other client nodes
Make sure the `$SI_TOKEN_FILE` is on all other nodes with file permissions
`0600`. The values `someuser` and `somehost` in the command below should
be changed to match the user and DNS name/IP address of the relay node.

    cd ~/skupper-podman
    . demo.conf
    scp someuser@somehost:$SI_TOKEN_FILE ~

When configuring Service Interconnect, the `--ingress none` option means
that this node does not accept incoming connections but only connects
to router nodes.

    cd ~/skupper-podman
    ./config-si-service.sh --ingress none

Finally, establish a link from this node to the router using the
following command.

    ./config-si-link.sh

## Check that the links are active
Check the status of the links from all the nodes.

    cd ~/skupper-podman
    . demo.conf
    skupper link status
