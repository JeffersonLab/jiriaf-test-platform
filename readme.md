# Workflow Setup, Deployment, and Monitoring Guide in JIRIAF

This document provides a comprehensive guide for setting up and running workflows in JIRIAF. It covers the following key aspects:

1. Project Identification: Defining a unique project ID for your workflow.
2. Prometheus Setup: Deploying a Prometheus instance for monitoring using Helm.
3. Workflow Deployment:
   - On Perlmutter and ORNL: Using Helm charts with specific parameters.
   - On EJFAT Nodes: Using Helm charts with custom configurations.
4. Additional Components: EJFAT node initialization, local EJFAT Helm charts, SLURM NERSC-ORNL Helm charts, and Prometheus monitoring setup.

The guide includes step-by-step instructions for:
- Starting a Prometheus instance
- Running workflows on Perlmutter and ORNL using SLURM and Helm
- Deploying workflows on EJFAT nodes using Helm

It also provides examples of commands, explanations of parameters, and references to additional resources such as the JIRIAF Fireworks GitHub repository for more detailed JRM setup and configurations.

This guide aims to provide researchers and developers with a clear, efficient approach to deploy and manage workflows across various environments within the JIRIAF ecosystem, ensuring proper monitoring and integration across different platforms.

## Components

### 1. EJFAT Node Initialization

The Experimental JLab Facility for AI and Test (EJFAT) nodes are initialized using scripts in the `init-jrm` directory. These scripts set up the environment for deploying workflows.

Key components:
- `node-setup.sh`: Sets up individual EJFAT nodes
- `launch-nodes.sh`: Launches multiple EJFAT nodes

For detailed information, see the [EJFAT Node Initialization README](main/local-ejfat/init-jrm/readme.md).

### 2. Local EJFAT Helm Charts

These charts are used to deploy workflows on EJFAT nodes. 

Key features:
- Main chart located in the `job/` directory
- Customizable deployment through `values.yaml`
- Includes templates for jobs, services, and monitoring

For usage instructions and details, refer to the [Local EJFAT README](main/local-ejfat/readme.md).

### 3. SLURM NERSC-ORNL Helm Charts

These charts are designed for deploying workflows on Perlmutter and ORNL environments.

Key features:
- Supports site-specific configurations (Perlmutter and ORNL)
- Includes scripts for batch job submission
- Integrates with Prometheus monitoring

For detailed usage instructions, see the [SLURM NERSC-ORNL README](main/slurm-nersc-ornl/readme.md).

### 4. Prometheus Monitoring

A custom Prometheus Helm chart sets up monitoring for the entire JIRIAF system.

Key components:
- Prometheus Server
- Persistent Volume for data storage
- ServiceMonitor for defining monitoring targets
- Initialization Job for setting up directory structure

For in-depth information, consult the [Prometheus Helm Chart README](main/prom/readme.md).

## Workflow Integration

The system is designed for seamless integration of workflows across different environments:

1. Initialize EJFAT nodes using the `init-jrm` scripts.
2. Deploy the Prometheus monitoring system using the provided Helm chart.
3. Deploy workflows on EJFAT nodes using the Local EJFAT Helm charts.
4. Deploy workflows on Perlmutter or ORNL using the SLURM NERSC-ORNL Helm charts.

All deployed workflows can be monitored by the single Prometheus instance, providing a unified view of the entire system.

## Usage

1. Set up EJFAT nodes:
   ```bash
   ./main/local-ejfat/init-jrm/launch-nodes.sh
   ```

2. Set up Perlmutter or ORNL nodes using JIRIAF Fireworks:
   Refer to the JIRIAF Fireworks repository at https://github.com/JeffersonLab/jiriaf-fireworks for detailed instructions on setting up the nodes for workflow execution.


3. Deploy Prometheus:
   ```bash
   cd main/prom
   ID=jlab-100g-nersc-ornl
   helm install $ID-prom prom/ --set Deployment.name=$ID
   ```

4. Deploy EJFAT workflows:
   ```bash
   cd main/local-ejfat
   ./launch_job.sh
   ```
   This script uses the following parameters:
   ```bash
   ID=jlab-100g-nersc-ornl
   INDEX=2
   ```
   You can modify these parameters in the script as needed.

5. Deploy SLURM NERSC-ORNL workflows:
   ```bash
   cd main/slurm-nersc-ornl
   ./batch-job-submission.sh
   ```
   This script uses the following default parameters:
   ```bash
   ID="jlab-100g-nersc-ornl"
   SITE="perlmutter"
   ERSAP_EXPORTER_PORT_BASE=20000
   JRM_EXPORTER_PORT_BASE=10000
   TOTAL_NUMBER=2
   ```
   You can modify these parameters in the script or pass the `TOTAL_NUMBER` as an argument.

These scripts automate the process of deploying multiple jobs, incrementing the necessary parameters (like port numbers and indices) for each job. This approach is more efficient for deploying multiple workflows in both the EJFAT and SLURM NERSC-ORNL environments.
## Customization

Each component (EJFAT, SLURM NERSC-ORNL, Prometheus) can be customized through their respective `values.yaml` files and additional configuration options. Refer to the individual README files for specific customization details.

## Troubleshooting

- Use standard Kubernetes commands (`kubectl get`, `kubectl logs`, `kubectl describe`) to diagnose issues.
- Check Prometheus metrics and alerts for system-wide monitoring.

For component-specific troubleshooting, consult the relevant README files linked above.

This overview provides a high-level understanding of the JIRIAF system. For detailed information on each component, please refer to the specific README files linked throughout this document.