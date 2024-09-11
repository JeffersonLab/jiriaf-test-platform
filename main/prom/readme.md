# Using the Prometheus Helm Chart for Custom Monitoring

## Prerequisites

Before deploying this Prometheus Helm chart, ensure you have the following components installed in your Kubernetes cluster:

1. [Prometheus Operator](https://github.com/prometheus-operator/prometheus-operator#quickstart)
2. [Kubernetes Metrics Server](https://github.com/kubernetes-sigs/metrics-server#installation)
3. [Helm](https://helm.sh/docs/intro/install/)

For detailed installation instructions, please refer to the official documentation linked above.

## Chart Overview

This Helm chart sets up a Prometheus server for custom monitoring in a Kubernetes environment. The chart name is `jiriaf-custom-monitoring-prom-server`, and it's currently at version 0.0.1.


```1:24:main/prom/Chart.yaml
apiVersion: v2
name: jiriaf-custom-monitoring-prom-server
description: This is to set up prometheus server for monitoring.

# A chart can be either an 'application' or a 'library' chart.
#
# Application charts are a collection of templates that can be packaged into versioned archives
# to be deployed.
#
# Library charts provide useful utilities or functions for the chart developer. They're included as
# a dependency of application charts to inject those utilities and functions into the rendering
# pipeline. Library charts do not define any templates and therefore cannot be deployed.
type: application

# This is the chart version. This version number should be incremented each time you make changes
# to the chart and its templates, including the app version.
# Versions are expected to follow Semantic Versioning (https://semver.org/)
version: 0.0.1

# This is the version number of the application being deployed. This version number should be
# incremented each time you make changes to the application. Versions are not expected to
# follow Semantic Versioning. They should reflect the version the application is using.
# It is recommended to use it with quotes.
appVersion: "1.16.0"
```


## Configuration

The chart can be configured using the `values.yaml` file:


```1:15:main/prom/values.yaml
Deployment:
  name: <project-id>
  namespace: default

PersistentVolume:
  node: jiriaf2302-control-plane
  path: /var/prom
  size: 5Gi
  
Prometheus:
  serviceaccount: prometheus-k8s
  namespace: monitoring

#https://github.com/prometheus-operator/kube-prometheus/blob/main/docs/customizations/monitoring-additional-namespaces.md
```


Key configuration options and their purposes:

1. `Deployment.name`: 
   - Names the job that creates the empty directory for persistent storage
   - Sets the path for the persistent volume
   - Used in the `serviceMonitorSelector` to select which services to monitor

2. `Deployment.namespace`:
   - Specifies the namespace for the job that creates the empty directory
   - Used in the `serviceMonitorNamespaceSelector` to select which namespaces to monitor

4. `PersistentVolume.node`:
   - Specifies the node affinity for the persistent volume

5. `PersistentVolume.path`:
   - Sets the host path for the persistent volume

6. `PersistentVolume.size`:
   - Defines the storage size for the persistent volume

7. `Prometheus.serviceaccount`:
   - Sets the service account for the Prometheus server

8. `Prometheus.namespace`:
   - Specifies the namespace for the Prometheus resources

These parameters are used across different components of the Helm chart:

- `prom-create_emptydir.yaml`: Creates an empty directory for persistent storage
- `prom-pv.yaml`: Defines the persistent volume for Prometheus data storage
- `prometheus.yaml`: Configures the main Prometheus server deployment

## Installation

To install this Helm chart, use the following command:

```bash
helm install <project-id>-prom prom/ --set Deployment.name=<project-id>
```

Replace `<project-id>` with your project identifier. This `<project-id>` is `ID` in this repository.

For example:

```bash
ID=jlab-100g-nersc-ornl
helm install $ID-prom prom/ --set Deployment.name=$ID
```

## Components

1. **Prometheus Server**: The main component defined in `prometheus.yaml`.
2. **Persistent Volume**: Created for Prometheus data storage, defined in `prom-pv.yaml`.
4. **Create Empty Dir**: Sets up the necessary directory structure for persistent storage, defined in `prom-create_emptydir.yaml`.

## Accessing Grafana

To access the Grafana dashboard for visualization:

1. Find the Grafana service and its port:
   ```bash
   kubectl get svc -n monitoring
   ```

2. Set up port forwarding:
   ```bash
   kubectl port-forward svc/grafana -n monitoring 3000:3000
   ```

3. Access Grafana in your web browser at `http://localhost:3000`

4. Log in with the default credentials (usually username: `admin`, password: `admin`)

## Integration with Workflows

This Prometheus setup is designed to work with a workflow system. It will collect metrics from the services and jobs created by the workflow system, allowing for monitoring of the entire process.

## Notes

- Ensure that the Kubernetes cluster has the necessary permissions and resources to create persistent volumes and run the Prometheus server.
- For any additional customization or advanced usage, refer to the Helm chart templates and the `values.yaml` file.