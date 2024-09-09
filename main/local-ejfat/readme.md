# Local EJFAT Helm Charts Documentation

This guide explains how to use the Helm charts in the `local-ejfat` folder to deploy workflows on EJFAT nodes.

## Prerequisites

- Helm 3 installed
- Kubernetes cluster access
- kubectl configured

## Chart Structure

The main chart is located in the `job/` directory. Key files include:

- [`Chart.yaml`](main/local-ejfat/job/Chart.yaml): Metadata for the chart
- [`values.yaml`](main/local-ejfat/job/values.yaml): Default configuration values
- Templates in the [`templates/`](main/local-ejfat/job/templates/) directory

## Deploying a Workflow

1. Set your project ID:

```bash
ID=your-project-id
```

2. Deploy the workflow using Helm:

```bash
helm install $ID-job-ejfat-<INDEX> local-ejfat/job/ --set Deployment.name=$ID-job-ejfat-<INDEX> --set Deployment.serviceMonitorLabel=$ID
```

Replace `<INDEX>` with a unique identifier for this workflow instance.

For a quick deployment, you can use the [`launch_job.sh`](main/local-ejfat/launch_job.sh) script:


```1:5:main/local-ejfat/launch_job.sh
#!/bin/bash

cd main/local-ejfat

ID=jlab-100g-nersc-ornl
INDEX=2
helm install $ID-job-ejfat-$INDEX job/ --set Deployment.name=$ID-job-ejfat-$INDEX --set Deployment.serviceMonitorLabel=$ID
```


## Customizing the Deployment

Edit the [`values.yaml`](main/local-ejfat/job/values.yaml) file to customize your deployment. Key settings include:


```1:14:main/local-ejfat/job/values.yaml
Deployment:
  name: this-name-is-changing
  namespace: default
  replicas: 1
  serviceMonitorLabel: ersap-test4 # this is the label for the serviceMonitor. It can be the same for multiple deployments if using a single prometheus instance.

  cpuUsage: "128"
  ejfatNode: "2"

  ersapSettings:
    image: gurjyan/ersap:v0.1 #jlabtsai/ersap:thread #gurjyan/ersap:v0.1
    cmd: /ersap/run-pipeline.sh
    file: /x.ersap

```


## Understanding the Templates

Key template files:

- [`job-job.yaml`](main/local-ejfat/job/templates/job-job.yaml): Defines the Kubernetes Job
- [`job-configmap.yaml`](main/local-ejfat/job/templates/job-configmap.yaml): Contains scripts for the job containers
- [`job-service.yaml`](main/local-ejfat/job/templates/job-service.yaml): Exposes the job as a Kubernetes Service
- [`prom-servicemonitor.yaml`](main/local-ejfat/job/templates/prom-servicemonitor.yaml): Sets up Prometheus monitoring

## Monitoring

The charts set up Prometheus monitoring. The [`prom-servicemonitor.yaml`](main/local-ejfat/job/templates/prom-servicemonitor.yaml) file defines how Prometheus should scrape metrics from your jobs.

## Cleanup

To delete a deployed job, use:

```bash
helm uninstall <release-name> -n <namespace>
```

Replace `<release-name>` with the name used during installation (e.g., `$ID-job-ejfat-0`).

## Troubleshooting

- Check pod status: `kubectl get pods -n <namespace>`
- View pod logs: `kubectl logs <pod-name> -n <namespace>`
- Describe a pod: `kubectl describe pod <pod-name> -n <namespace>`

## Integration with Other Workflows

The local EJFAT charts are designed to work alongside workflows on Perlmutter and ORNL. For a complete setup:

1. Start a Prometheus instance for your project:

```bash
helm install $ID-prom prom/ --set Deployment.name=$ID
```

2. Deploy workflows on Perlmutter or ORNL using the `slurm-nersc-ornl/launch_job.sh` script as described in the main README.

3. Deploy EJFAT workflows using the instructions in this document.

By following these steps, you can create a comprehensive workflow setup across different environments, all monitored by a single Prometheus instance.

Remember to replace `<namespace>` with the actual namespace you're using (default is "default" unless specified otherwise).

## Additional Files

- [`job-deployment.yaml`](main/local-ejfat/job/job-deployment.yaml): Defines the Kubernetes Deployment
- [`.helmignore`](main/local-ejfat/job/.helmignore): Specifies files to ignore in the Helm chart
- [`_helpers.tpl`](main/local-ejfat/job/templates/_helpers.tpl): Contains helper templates for the chart
- [`node-setup.sh`](main/local-ejfat/init-jrm/node-setup.sh): Script for setting up EJFAT nodes
- [`launch-nodes.sh`](main/local-ejfat/init-jrm/launch-nodes.sh): Script for launching EJFAT nodes

These files provide additional configuration and setup options for the EJFAT environment.