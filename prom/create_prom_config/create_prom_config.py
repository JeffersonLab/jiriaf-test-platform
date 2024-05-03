import yaml

# Open the YAML file and load its contents.
with open('/prom/prometheus-temp.yml', 'r') as file:
    data = yaml.safe_load(file)

# num_proc_nodes
num_proc_nodes = 25

# global labels
global_labels = {
    "task_name": "ersap-100g",
    "num_proc_nodes": str(num_proc_nodes),
    "comupte_site": "nersc",
    "run_type": "production",
    "run_date": "2024-05-02",
}

data['scrape_configs'] = []

# Loop from 1 to 25.
for i in range(1, num_proc_nodes + 1):
    # Format i as a two-digit number.
    i_padded = f"{i:02d}"

    # Define the new jobs.
    new_jobs = [
        {
            'job_name': f'j-vk-{i_padded}',
            'scheme': 'https',
            'static_configs': [{'targets': [f'localhost:100{i_padded}'], 'labels': global_labels.copy()}],
            'metrics_path': '/metrics/resource',
            'tls_config': {'insecure_skip_verify': True},
        },
        {
            'job_name': f'j-ersap-process-exporter-{i_padded}',
            'static_configs': [{'targets': [f'localhost:200{i_padded}'], 'labels': global_labels.copy()}],

        },
        {
            'job_name': f'vd-ersap-{i_padded}',
            'static_configs': [{'targets': [f'localhost:300{i_padded}'], 'labels': global_labels.copy()}],
        },
        {
            'job_name': f'vd-ejfat-{i_padded}',
            'static_configs': [{'targets': [f'localhost:400{i_padded}'], 'labels': global_labels.copy()}],
        }
    ]

    # Add the new jobs to the scrape_configs key
    data['scrape_configs'].extend(new_jobs)

# Write the modified data back to the YAML file.
with open('/prom/prometheus-out.yml', 'w') as file:
    yaml.safe_dump(data, file)