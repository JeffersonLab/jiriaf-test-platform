
# Workflow Setup Instructions

Follow these steps to deploy and run workflows using Prometheus on Perlmutter, ORNL, and EJFAT nodes.

## 1. Define the Project ID

Set `ID` as your project identifier. This will also serve as the name of the Prometheus instance.

## 2. Start the Prometheus Instance

Run the following command to start a Prometheus instance with the defined project ID:

```bash
helm install $ID-prom prom/ --set Deployment.name=$ID
```

## 3. Run Workflows on Perlmutter and ORNL

To start a workflow on Perlmutter or ORNL, use the `launch_job.sh` script with the following syntax:

```bash
slurm-nersc-ornl/launch_job.sh <ID> <INDEX> <SITE> <ersap-exporter-port> <jrm-exporter-port>
```

### Example:
```bash
ID=jlab-100g-nersc-ornl
slurm-nersc-ornl/launch_job.sh $ID perlmutter-0 perlmutter 20000 10000
```

### Parameters:
- `<ID>`: The project ID.
- `<INDEX>`: The index of the workflow (must be unique).
- `<SITE>`: The site where the workflow is running. Use either `perlmutter` or `ornl`.
- `<ersap-exporter-port>`: The port number for the ERSAP exporter.
- `<jrm-exporter-port>`: The port number for the JRM exporter.

## 4. Run Workflows on EJFAT Nodes

To start a workflow on EJFAT nodes, use the `helm install` command with the following syntax:

```bash
helm install $ID-job-<INDEX> local-ejfat/job/ --set Deployment.name=$ID-job-<INDEX> --set Deployment.serviceMonitorLabel=$ID
```

### Example:
```bash
ID=jlab-100g-nersc-ornl
helm install $ID-job-ejfat-0 local-ejfat/job/ --set Deployment.name=$ID-job-ejfat-0 --set Deployment.serviceMonitorLabel=$ID
```

### Parameters:
- `<ID>`: The project ID.
- `<INDEX>`: The index of the workflow (must be unique).

## Additional Notes

- Ensure that `<INDEX>` is unique for each workflow you start.
- The `<ersap-exporter-port>` and `<jrm-exporter-port>` values are specified when launching the JRMs using the Docker images `jlabtsai/jrm-fw:perlmutter` or `jlabtsai/jrm-fw:ornl`.
- For more details on JRM setup and configurations, refer to the [JIRIAF Fireworks GitHub repository](https://github.com/JeffersonLab/jiriaf-fireworks.git).
