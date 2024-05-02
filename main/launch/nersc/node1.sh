#!/bin/bash

export CONTROL_PLANE_IP="jiriaf2301"
export APISERVER_PORT="35679"
export NODENAME="vk-nersc1"
export KUBECONFIG="/global/homes/j/jlabtsai/run-vk/kubeconfig/$CONTROL_PLANE_IP"
export VKUBELET_POD_IP="172.17.0.1"
export KUBELET_PORT="10001"

export JIRIAF_WALLTIME="0" # "0" if no limit
export JIRIAF_NODETYPE="cpu"
export JIRIAF_SITE="nersc"

echo "JRM: $NODENAME is running... on $HOSTNAME"

# check if ssh tunnel is running, if not, start it as a follow
ssh -NfL $APISERVER_PORT:localhost:$APISERVER_PORT login04
ssh -NfR $KUBELET_PORT:localhost:$KUBELET_PORT login04

## echo walltime, nodetype, site
echo "walltime: $JIRIAF_WALLTIME; nodetype: $JIRIAF_NODETYPE; site: $JIRIAF_SITE"

# ssh -NfL $APISERVER_PORT:localhost:$APISERVER_PORT $CONTROL_PLANE_IP
# ssh -NfR *:$KUBELET_PORT:localhost:$KUBELET_PORT $CONTROL_PLANE_IP 
# To make sure the port is open to all interfaces, one has to set GatewayPorts to yes in /etc/ssh/sshd_config and run sudo service ssh restart at mylin.

shifter --image=docker:jlabtsai/vk-cmd:main -- /bin/bash -c "cp -r /vk-cmd `pwd`/$NODENAME

cd `pwd`/$NODENAME

echo "api-server config: $KUBECONFIG; nodename: $NODENAME is runnning..."
echo "vk ip: $VKUBELET_POD_IP from view of metrics server; vk kubelet port: $KUBELET_PORT"

./start.sh $KUBECONFIG $NODENAME $VKUBELET_POD_IP $KUBELET_PORT $JIRIAF_WALLTIME $JIRIAF_NODETYPE $JIRIAF_SITE