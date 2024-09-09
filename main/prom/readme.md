# Prometheus Helm Chart for Custom Monitoring

This Helm chart sets up a Prometheus server for custom monitoring in a Kubernetes environment.

## Chart Details

- **Chart Name**: jiriaf-custom-monitoring-prom-server
- **Description**: Sets up a Prometheus server for monitoring
- **Type**: Application
- **Version**: 0.0.1
- **App Version**: 1.16.0

For more details, see:


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


## Components

### 1. Prometheus Server

The main component of this chart is a Prometheus server, defined in:


```1:64:main/prom/templates/prometheus.yaml
apiVersion: monitoring.coreos.com/v1
kind: Prometheus
metadata:
  name: {{ .Values.Deployment.name}}
  namespace: {{ .Values.Prometheus.namespace}}
  labels:
    app.kubernetes.io/component: prometheus
    app.kubernetes.io/instance: k8s
    app.kubernetes.io/name: prometheus
    app.kubernetes.io/part-of: kube-prometheus
    app.kubernetes.io/version: 2.32.1
spec:
  image: quay.io/prometheus/prometheus:v2.32.1
  nodeSelector:
      kubernetes.io/os: linux
  replicas: 1
  resources:
    requests:
      memory: 400Mi
  ruleSelector: {}
  securityContext:
    fsGroup: 2000
    runAsNonRoot: true
    runAsUser: 1000
  serviceAccountName: {{ .Values.Prometheus.serviceaccount}}
  # serviceMonitorNamespaceSelector: {} #match all namespaces
  serviceMonitorNamespaceSelector:
    matchLabels:
      kubernetes.io/metadata.name: {{ .Values.Deployment.namespace}}
  serviceMonitorSelector: 
    matchLabels:
      app: {{ .Values.Deployment.name}}
  version: 2.32.1
  retention: 720d
  storage:
    volumeClaimTemplate:
      spec:
        storageClassName: local-storage-{{ .Values.Deployment.name}}
        accessModes: ["ReadWriteOnce"]
        resources:
          requests:
            storage: {{ .Values.PersistentVolume.size}}

---
# add service for prometheus
apiVersion: v1
kind: Service
metadata:
  name: prometheus-{{ .Values.Deployment.name}}
  namespace: {{ .Values.Prometheus.namespace}}
  labels:
    app.kubernetes.io/component: prometheus
    app.kubernetes.io/instance: k8s
    app.kubernetes.io/name: prometheus
    app.kubernetes.io/part-of: kube-prometheus
    app.kubernetes.io/version: 2.32.1
spec:
  ports:
    - name: web
      port: 9090
      targetPort: 9090
  selector:
    prometheus: {{ .Values.Deployment.name}}
  type: ClusterIP
```


Key features:
- Uses Prometheus image v2.32.1
- Configurable resources and storage
- Service monitor selector based on deployment name
- 720 days data retention

### 2. Persistent Volume

A persistent volume is created for Prometheus data storage:


```1:22:main/prom/templates/prom-pv.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: prometheus-{{ .Values.Deployment.name}}
spec:
  capacity:
    storage: {{ .Values.PersistentVolume.size}}
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: local-storage-{{ .Values.Deployment.name}}
  local:
    path: "{{ .Values.PersistentVolume.path}}/{{ .Values.Deployment.name}}"
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - {{ .Values.PersistentVolume.node}}
```


### 3. Service Monitor

A ServiceMonitor resource is created to define which services Prometheus should monitor:


```1:12:main/prom/prom-servicemonitor.yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: {{.Values.Deployment.name}}
  namespace: {{.Values.Deployment.namespace}}
  labels:
    app: {{.Values.Deployment.name}}
spec:
  selector:
    matchLabels:
      app: {{.Values.Deployment.name}}
  endpoints: []
```


### 4. Initialization Job

A job is created to set up the necessary directory structure:


```1:30:main/prom/templates/prom-create_emptydir.yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: create-emptydir-{{ .Values.Deployment.name}}
  namespace: {{ .Values.Deployment.namespace}}
spec:
  template:
    spec:
      containers:
      - name: my-container
        image: busybox
        command: ['sh', '-c', 'mkdir -p {{ .Values.PersistentVolume.path}}/{{ .Values.Deployment.name}}']
        volumeMounts:
        - name: var-volume
          mountPath: /var
      volumes:
      - name: var-volume
        hostPath:
          path: /var
          type: DirectoryOrCreate
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: kubernetes.io/hostname
                operator: In
                values:
                - {{ .Values.PersistentVolume.node}}
      restartPolicy: Never
```


## Configuration

The chart can be configured using the `values.yaml` file:


```1:15:main/prom/values.yaml
Deployment:
  name: ersap-test4
  namespace: default
  replicas: 1

PersistentVolume:
  node: jiriaf2302-control-plane
  path: /var/prom
  size: 5Gi
  
Prometheus:
  serviceaccount: prometheus-k8s
  namespace: monitoring

#https://github.com/prometheus-operator/kube-prometheus/blob/main/docs/customizations/monitoring-additional-namespaces.md
```


Key configuration options:
- `Deployment.name`: Name of the deployment
- `Deployment.namespace`: Namespace for the deployment
- `PersistentVolume`: Configuration for the persistent volume
- `Prometheus`: Prometheus-specific settings

## Usage

To install this Helm chart, use the following command:

```bash
helm install <release-name> prom/ --set Deployment.name=<project-id>
```

Replace `<release-name>` with your desired release name and `<project-id>` with your project identifier.

For example:

```bash
ID=jlab-100g-nersc-ornl
helm install $ID-prom prom/ --set Deployment.name=$ID
```

## Integration with Workflows

This Prometheus setup is designed to work with a workflow system. It will collect metrics from the services and jobs created by the workflow system, allowing for monitoring of the entire process.

## Notes

- This chart is part of a larger system for running and monitoring workflows across different environments.
- Ensure that the Kubernetes cluster has the necessary permissions and resources to create the persistent volumes and run the Prometheus server.
- The ServiceMonitor is configured to match labels based on the deployment name, ensuring that it only monitors the relevant services for each project.

For any additional customization or advanced usage, refer to the Helm chart templates and the `values.yaml` file.