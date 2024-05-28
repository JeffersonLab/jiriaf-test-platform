#!/bin/bash

export CONTROL_PLANE_IP="jiriaf2302" #"jiriaf2301"
export APISERVER_PORT="38687" #35679
export NODENAME="ejfat-$1"
export KUBECONFIG="~/.kube/config"
export VKUBELET_POD_IP="172.17.0.1"
export KUBELET_PORT="100""$1"

export JIRIAF_WALLTIME="0" # "0" if no limit
export JIRIAF_NODETYPE="cpu"
export JIRIAF_SITE="ejfat"

echo "JRM: $NODENAME is running... on $HOSTNAME"

# check if ssh tunnel is running, if not, start it as a follow
ssh -NfL $APISERVER_PORT:localhost:$APISERVER_PORT login04
ssh -NfR $KUBELET_PORT:localhost:$KUBELET_PORT login04

# start SSHs for other prometheus exporters
export ersap_exporter="200""$1"
export process_exporter="300""$1"
export ejfat_exporter="400""$1"
echo "ersap exporter: $ersap_exporter; process exporter: $process_exporter; ejfat exporter: $ejfat_exporter"

ssh -NfR $ersap_exporter:localhost:2221 login04
ssh -NfR $process_exporter:localhost:1776 login04
ssh -NfR $ejfat_exporter:localhost:8080 login04


## echo walltime, nodetype, site
echo "walltime: $JIRIAF_WALLTIME; nodetype: $JIRIAF_NODETYPE; site: $JIRIAF_SITE"

# ssh -NfL $APISERVER_PORT:localhost:$APISERVER_PORT $CONTROL_PLANE_IP
# ssh -NfR *:$KUBELET_PORT:localhost:$KUBELET_PORT $CONTROL_PLANE_IP 
# To make sure the port is open to all interfaces, one has to set GatewayPorts to yes in /etc/ssh/sshd_config and run sudo service ssh restart at mylin.

container_id=$(docker run -itd --rm --name vk-cmd $VK_CMD_IMAGE)
docker cp ${container_id}:/vk-cmd `pwd` && docker stop ${container_id}

cd `pwd`/$NODENAME

echo "api-server config: $KUBECONFIG; nodename: $NODENAME is runnning..."
echo "vk ip: $VKUBELET_POD_IP from view of metrics server; vk kubelet port: $KUBELET_PORT"

./start.sh $KUBECONFIG $NODENAME $VKUBELET_POD_IP $KUBELET_PORT $JIRIAF_WALLTIME $JIRIAF_NODETYPE $JIRIAF_SITE


