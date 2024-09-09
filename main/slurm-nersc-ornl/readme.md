# How to Use the slurm-nersc-ornl Helm Charts

## 1. Prerequisites

- Helm 3 installed
- Kubernetes cluster access
- kubectl configured

## 2. Chart Structure

The main chart is located in the [`job/`](main/slurm-nersc-ornl/job/) directory. Key files include:

- [`Chart.yaml`](main/slurm-nersc-ornl/job/Chart.yaml): Metadata for the chart
- [`values.yaml`](main/slurm-nersc-ornl/job/values.yaml): Default configuration values
- Templates in the [`templates/`](main/slurm-nersc-ornl/job/templates/) directory

## 3. Customizing the Deployment

Edit the [`values.yaml`](main/slurm-nersc-ornl/job/values.yaml) file to customize your deployment. Key settings include:


```1:7:main/slurm-nersc-ornl/job/values.yaml
Deployment:
  name: this-name-is-changing
  namespace: default
  replicas: 1
  serviceMonitorLabel: ersap-test4 # this is the label for the serviceMonitor. It can be the same for multiple deployments if using a single prometheus instance.
  site: perlmutter #ornl

```


## 4. Launching a Job

Use the [`launch_job.sh`](main/slurm-nersc-ornl/launch_job.sh) script to deploy a job:

```shell
./launch_job.sh <ID> <INDEX> <SITE> <ersap-exporter-port> <jrm-exporter-port>
```

Example:
```shell
./launch_job.sh jlab-100g-nersc-ornl 0 perlmutter 20000 10000
```

This script sets up the necessary parameters and runs a Helm install command.

## 5. Batch Job Submission

For submitting multiple jobs, use the [`batch-job-submission.sh`](main/slurm-nersc-ornl/batch-job-submission.sh) script:

```shell
./batch-job-submission.sh
```

This script will create multiple jobs with incrementing port numbers. The script parameters are:

- `ID`: The base identifier for the jobs (default: "jlab-100g-nersc-ornl")
- `SITE`: The deployment site, either "perlmutter" or "ornl" (default: "perlmutter")
- `ERSAP_EXPORTER_PORT_BASE`: The base port for ERSAP exporter (default: 20000)
- `JRM_EXPORTER_PORT_BASE`: The base port for JRM exporter (default: 10000)
- `TOTAL_NUMBER`: The total number of jobs to submit (passed as an argument)

## 6. Understanding the Templates

Key template files:

- [`job-job.yaml`](main/slurm-nersc-ornl/job/templates/job-job.yaml): Defines the Kubernetes Job
- [`job-configmap.yaml`](main/slurm-nersc-ornl/job/templates/job-configmap.yaml): Contains scripts for the job containers
- [`job-service.yaml`](main/slurm-nersc-ornl/job/templates/job-service.yaml): Exposes the job as a Kubernetes Service
- [`prom-servicemonitor.yaml`](main/slurm-nersc-ornl/job/templates/prom-servicemonitor.yaml): Sets up Prometheus monitoring

## 7. Site-Specific Configurations

The charts support different configurations for Perlmutter and ORNL sites. This is handled in the [`job-configmap.yaml`](main/slurm-nersc-ornl/job/templates/job-configmap.yaml):


```12:17:main/slurm-nersc-ornl/job/templates/job-configmap.yaml
    {{- if eq .Values.Deployment.site "perlmutter" }}
        shifter --image=gurjyan/ersap:v0.1 -- /ersap/run-pipeline.sh
    {{- else }}
        export PR_HOST=$(hostname -I | awk '{print $2}')
        apptainer run ~/ersap_v0.1.sif -- /ersap/run-pipeline.sh
    {{- end }}
```


## 8. Monitoring

The charts set up Prometheus monitoring. The [`prom-servicemonitor.yaml`](main/slurm-nersc-ornl/job/templates/prom-servicemonitor.yaml) file defines how Prometheus should scrape metrics from your jobs.

## 9. Cleanup

To delete a deployed job, use:

```shell
helm uninstall <release-name> -n <namespace>
```

Replace `<release-name>` with the name used during installation (e.g., `jlab-100g-nersc-ornl-job-0`).

## 10. Troubleshooting

- Check pod status: `kubectl get pods -n <namespace>`
- View pod logs: `kubectl logs <pod-name> -n <namespace>`
- Describe a pod: `kubectl describe pod <pod-name> -n <namespace>`

Remember to replace `<namespace>` with the actual namespace you're using (default is "default" unless specified otherwise).

This documentation provides a high-level overview of how to use and customize the Helm charts in the slurm-nersc-ornl folder. For more detailed information about specific components, refer to the individual files linked in this document.