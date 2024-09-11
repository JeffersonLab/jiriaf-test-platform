# EJFAT Node Initialization

This directory contains scripts for initializing EJFAT (Experimental JLab Facility for AI and Test) nodes. These scripts are crucial for setting up the environment before deploying workflows.

## Key Files

1. `node-setup.sh`: Sets up individual EJFAT nodes.
2. `launch-nodes.sh`: Launches multiple EJFAT nodes.

## node-setup.sh

This script performs the following tasks:
- Sets environment variables for the node
- Pulls the necessary Docker image
- Starts the virtual kubelet process

Key features:
```shell:main/local-ejfat/init-jrm/node-setup.sh
startLine: 3
endLine: 11
```

- Pulls and runs the `jlabtsai/vk-cmd:main` Docker image
- Starts the virtual kubelet process with specified parameters

## launch-nodes.sh

This script:
- Sets up SSH tunnels for each node
- Copies the `node-setup.sh` script to each node
- Executes `node-setup.sh` on each node

Key features:
```shell:main/local-ejfat/init-jrm/launch-nodes.sh
startLine: 3
endLine: 16
```

## Usage

To initialize EJFAT nodes:

1. Ensure you have SSH access to the EJFAT nodes.
2. Run the `launch-nodes.sh` script:

```bash
./launch-nodes.sh
```

This will set up all the specified EJFAT nodes (currently set to initialize node 2).

## Customization

- To change the number of nodes or their range, modify the `seq` command in `launch-nodes.sh`:

```bash
for i in $(seq <start> <end>) # This represents the node names, e.g. ejfat-1, ejfat-2, ejfat-3, etc.
```

- To adjust node-specific settings, modify the `node-setup.sh` script. Key variables include:
  - `JIRIAF_WALLTIME`: Set to "0" for no time limit
  - `JIRIAF_NODETYPE`: Currently set to "cpu"
  - `JIRIAF_SITE`: Set to "ejfat"

## Integration with Helm Charts

After initializing the EJFAT nodes, you can proceed to deploy workflows using the Helm charts as described in the main `local-ejfat` documentation. The initialized nodes will be available for scheduling your jobs.

Remember to ensure that the `nodeSelector` and `tolerations` in your Helm charts match the configuration of these initialized nodes for proper scheduling.

## Troubleshooting

If you encounter issues during node initialization:

1. Check SSH connectivity to the EJFAT nodes
2. Verify that the Docker daemon is running on the nodes
3. Ensure the `jlabtsai/vk-cmd:main` image is accessible
4. Check the logs of the virtual kubelet process on the nodes

For more detailed information on the EJFAT setup and its integration with the overall workflow, refer to the main `README.md` in the `local-ejfat` directory.
