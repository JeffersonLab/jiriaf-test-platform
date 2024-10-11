#!/bin/bash

export NODENAME=jrm-ejfat-"$1"
export KUBECONFIG="$HOME/.kube/config"
export VKUBELET_POD_IP=$2
# set kubelet port as 10000 + $1
export KUBELET_PORT=1990  #$((10000 + $1))

export JIRIAF_WALLTIME="0" # "0" if no limit
export JIRIAF_NODETYPE="cpu"
export JIRIAF_SITE="ejfat"

echo "JRM: $NODENAME is running... on $NODENAME"

## echo walltime, nodetype, site
echo "walltime: $JIRIAF_WALLTIME; nodetype: $JIRIAF_NODETYPE; site: $JIRIAF_SITE"

export VK_CMD_IMAGE="docker://jlabtsai/vk-cmd:main"
podman pull $VK_CMD_IMAGE

container_id=$(podman run -itd --rm --name vk-cmd $VK_CMD_IMAGE)
podman cp ${container_id}:/vk-cmd `pwd` && podman stop ${container_id}

cd `pwd`/vk-cmd

echo "api-server config: $KUBECONFIG; nodename: $NODENAME is runnning..."
echo "vk ip: $VKUBELET_POD_IP from view of metrics server; vk kubelet port: $KUBELET_PORT"

./start.sh $KUBECONFIG $NODENAME $VKUBELET_POD_IP $KUBELET_PORT $JIRIAF_WALLTIME $JIRIAF_NODETYPE $JIRIAF_SITE


