# Local EJFAT Helm Charts Documentation

This guide explains how to use the Helm charts in the `local-ejfat` folder to deploy workflows on EJFAT nodes.

## Prerequisites

- Helm 3 installed
- Kubernetes cluster access
- kubectl configured

## Chart Structure

The main chart is located in the `job/` directory. Key files include:

- `Chart.yaml`: Metadata for the chart
- `values.yaml`: Default configuration values
- Templates in the `templates/` directory

## Step-by-Step Usage

1. **Setup Environment:**
   - Ensure you have Helm 3 installed, access to a Kubernetes cluster, and kubectl configured.
   - Clone the repository and navigate to the `local-ejfat` folder:
     ```bash
     git clone https://github.com/JeffersonLab/jiriaf-test-platform.git
     cd jiriaf-test-platform/main/local-ejfat
     ```

2. **Set Project ID:**
   - Export your project ID as an environment variable:
     ```bash
     export ID=your-project-id # e.g. jlab-100g-nersc-ornl
     ```

3. **Customize Deployment (Optional):**
   - Edit `job/values.yaml` to customize your deployment. Key settings include:
     ```yaml
     Deployment:
       name: this-name-is-changing
       namespace: default
       replicas: 1
       serviceMonitorLabel: ersap-test4
       cpuUsage: "128"
       ejfatNode: "2"
     ersapSettings:
       image: gurjyan/ersap:v0.1
       cmd: /ersap/run-pipeline.sh
       file: /x.ersap
     ```

4. **Deploy Prometheus (If not already running):**
  - Refer to `main/prom/readme.md` for instructions on how to install and configure Prometheus.
  - Check if the prometheus instance is running:
    ```bash
    helm ls | grep "$ID-prom"
    ```
    If the command returns no results, it means there's no Prometheus instance for your project ID.

  - Install a Prometheus instance for your project if it's not already running:
    ```bash
     cd main/prom
     helm install $ID-prom prom/ --set Deployment.name=$ID
     ```


5. **Deploy EJFAT Workflow:**
   - Use the `launch_job.sh` script to deploy the EJFAT workflow:
     ```bash
     cd main/local-ejfat
     ./launch_job.sh
     ```
   - This script uses the following variables:
     - `ID`: The project identifier (e.g., jlab-100g-nersc-ornl)
     - `INDEX`: A unique index for the job (e.g., 2)


6. **Monitor Deployment:**
   - Check Helm release: `helm ls | grep $ID-job-ejfat-$INDEX-job`
   - Check pod status: `kubectl get pods`
   - Describe a pod: `kubectl describe pod <pod-name>`

7. **Manage Deployed Jobs:**
   - List deployed jobs: `helm ls`
   - Delete a deployed job:
     ```bash
     helm uninstall $ID-job-ejfat-<INDEX>
     ```

8. **Clean Up EJFAT Nodes:**
   - After uninstalling the Helm release, manually delete containers on EJFAT nodes:
     1. Log in to each EJFAT node used in your deployment.
     2. List all containers: `docker ps -a`
     3. Identify containers related to your job.
     4. Remove these containers: `docker rm -f <container-id>`

9. **Integration with Other Workflows:**
   - Deploy workflows on Perlmutter or ORNL using the `slurm-nersc-ornl/launch_job.sh` script as described in the main README.
   - Ensure all workflows use the same Prometheus instance for unified monitoring.

## Understanding the Templates

Key template files:

- `job-job.yaml`: Defines the Kubernetes Job
- `job-configmap.yaml`: Contains scripts for the job containers
- `job-service.yaml`: Exposes the job as a Kubernetes Service
- `prom-servicemonitor.yaml`: Sets up Prometheus monitoring

## Monitoring

The charts set up Prometheus monitoring. The `prom-servicemonitor.yaml` file defines how Prometheus should scrape metrics from your jobs.

## Troubleshooting

- Check pod status: `kubectl get pods`
- View pod logs: `kubectl logs <pod-name>`
- Describe a pod: `kubectl describe pod <pod-name>`

## Additional Files

- `job-deployment.yaml`: Defines the Kubernetes Deployment
- `.helmignore`: Specifies files to ignore in the Helm chart
- `_helpers.tpl`: Contains helper templates for the chart
- `node-setup.sh`: Script for setting up EJFAT nodes
- `launch-nodes.sh`: Script for launching EJFAT nodes

These files provide additional configuration and setup options for the EJFAT environment.