# EJFAT Node Initialization

This directory contains scripts for initializing JRMs on EJFAT nodes.

## Key Files

1. `node-setup.sh`: Sets up individual EJFAT nodes.
2. `launch-nodes.sh`: Launches EJFAT nodes.



## Step-by-Step Usage

![EJFAT Node Initialization Flow Chart](../../../image/ejfat_node_initialization_flow_chart.png)

1. **Download the Repository**
   Clone the GitHub repository to your local machine:
   ```bash
   git clone https://github.com/JeffersonLab/jiriaf-test-platform.git
   cd jiriaf-test-platform/main/local-ejfat/init-jrm
   ```

2. **Set API Server Port**
   Check your Kubernetes configuration file at `~/.kube/config` to find the correct API server port. Update the `APISERVER_PORT` in `launch-nodes.sh` to match this port.

3. **Customize Node Selection**
   By default, the script initializes only `ejfat-2`. To change this:
   - Open `launch-nodes.sh` in a text editor.
   - Locate the line: `for i in $(seq 2 2)`
   - Modify the numbers to select different nodes. For example:
     - `$(seq 1 3)` initializes nodes 1, 2, and 3.
     - `$(seq 5 7)` initializes nodes 5, 6, and 7.

4. **Prepare SSH Access and Docker**
   - Ensure you have SSH access to the EJFAT nodes you intend to initialize.
   - Verify that Docker is installed and running on each EJFAT node. The script requires Docker to pull and run necessary images.

5. **Run the Launch Script**
   Execute the `launch-nodes.sh` script:
   ```bash
   ./launch-nodes.sh
   ```

6. **Script Execution Process**
   For each selected node, the script will:
   - Set up an SSH tunnel for port forwarding.
   - Copy `node-setup.sh` to the target node.
   - Execute `node-setup.sh` on the node with appropriate parameters.

7. **Wait for Completion**
   The script will wait for all node setup processes to complete.

## Special Cases

- Node 7 is treated as a special case and renamed to "fs". If you're including node 7, be aware of this naming convention in the script.

## Troubleshooting

If you encounter issues:
1. Verify SSH connectivity to the target nodes.
2. Check if the API server port is available on both local and remote machines.
3. Ensure `node-setup.sh` is present in the same directory as `launch-nodes.sh`.

For more detailed information, refer to the comments in `launch-nodes.sh` and `node-setup.sh`.
