# Monitoring Stack Setup

## Introduction

This project sets up a comprehensive **monitoring stack** to track both metrics and logs using various popular tools:
- **Prometheus**: For scraping and storing metrics.
- **Grafana**: For visualizing metrics and logs through dashboards.
- **Promtail**: For collecting logs from containers and forwarding them to Loki.
- **Loki**: For centralized logging storage.
- **cAdvisor**: For monitoring container metrics.
- **Node Exporter**: For collecting node/system-level metrics.
- **Docker Logging Plugin**: To send logs from Docker containers to Loki.

All of these tools are installed and configured using **Docker Compose**, providing a streamlined way to deploy and manage the monitoring stack.

## Prerequisites

Before you begin, ensure you have the following:
- Docker and Docker Compose installed on the server.
- Basic understanding of Docker and monitoring/logging concepts.
- Access to multiple servers (if you're setting up multi-server monitoring).

### ⚠️ Important Considerations

1. **Docker Plugin for Container Logging**: 
   - To collect logs from Docker containers using Loki, you need to configure the Docker client logging plugin to use Loki as the default log driver. 
   - **Custom Shell Script**: Use the provided shell script (setup_docker_loki_plugin.sh) to install the plugin.
   - The script will:
     
     - Install the docker loki logging plugin.
     - Store the names of all currently running containers in a temporary file.
     - Restart the Docker daemon.
     - Restart all previously running containers after Docker has restarted.

2. **Logging of Existing Containers**:
   - For containers to be logged, you need to include a logging block in the Docker Compose file for each container. Use the following configuration:
   
     ```yaml
     logging:
       driver: loki
       options:
         loki-url: "http://<MONITRING_SERVER_IP>/loki/api/v1/push"
     ```

## Setup Instructions

Follow these steps to get your monitoring stack up and running:

### 1. Clone the Repository

Start by cloning this repository to your monitoring server.

```bash
git clone <repo_url>
cd promtailloki
```

### 2. Configure Environment Variables
Edit the .env file to update the Loki URL and other configurations specific to your environment.

```bash
nano .env
```

Make sure to replace the placeholder values with your actual monitoring server IP.

For example:

```bash
LOKI_URL=http://<YOUR_MONITORING_SERVER_IP>:3100
```

### 3. Edit Prometheus Configuration
To include other servers as monitoring targets, edit the prometheus.yml file and add the IP addresses of the servers you want to monitor under the static_configs section.

```yaml

scrape_configs:
  - job_name: 'node_exporter'
    static_configs:
      - targets: 
        - '<SERVER_ONE_IP>:9100'
        - '<SERVER_TWO_IP>:9100'

  - job_name: 'cadvisor'
    static_configs:
      - targets: 
        - '<SERVER_ONE_IP>:8080'
        - '<SERVER_TWO_IP>:8080'

```


### 4. Start the Stack
Once your configurations are ready, start the monitoring stack using Docker Compose:

```bash
docker-compose up -d
```

### 5. Verify the Setup
You can verify the setup by accessing Grafana:

Open your browser and navigate to ``` http://<YOUR_MONITORING_SERVER_IP>:3000.```

Login with the default credentials:

- Username: admin
- Password: admin

### 6. Grafana Resources

The following resources will be provisioned within Grafana:

- Dashboards
- Alerting Rules
- Notification Policy for Routing
- Contact Point (Email)

### Conclusion
This monitoring stack provides a flexible and powerful way to monitor and log metrics across multiple servers and containers. With Prometheus, Loki, and Grafana, you can easily scale and visualize your data in real time.

