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
   - If you want to collect logs from Docker containers using Loki, you will need to configure the Docker client logging plugin to use Loki as the default log driver. 
   - This **requires restarting the Docker daemon**, which will **stop all running containers**. Plan for this accordingly.
   
2. **Logging of Newly Created Containers**:
   - Only containers that are created **after** the Docker logging configuration will be tracked and logged. Containers that are restarted but created before this configuration **will not** be logged.

## Setup Instructions

Follow these steps to get your monitoring stack up and running:

### 1. Clone the Repository

Start by cloning this repository to your monitoring server.

bash
git clone https://github.com/Ravi4090/promtailloki.git
cd promtailloki

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

### 4. Restart Docker Daemon for Logging

If you plan to use the Docker logging plugin for sending logs to Loki, you'll need to configure Docker to use Loki as the default log driver.

For the logging functionality to work with Loki, you need to install the Docker logging plugin:

```bash
docker plugin install grafana/loki-docker-driver:latest --alias loki --grant-all-permissions
```

Update the Docker daemon configuration by editing /etc/docker/daemon.json:

```json
Copy code
{
  "log-driver": "loki",
  "log-opts": {
    "loki-url": "http://<YOUR_MONITORING_SERVER_IP>:3100/loki/api/v1/push"
  }
}
```

Restart the Docker service to apply the changes:

```bash
sudo systemctl restart docker
```

### 5. Start the Stack
Once your configurations are ready, start the monitoring stack using Docker Compose:

```bash
docker-compose up -d
```
⚠️ Note: Restarting Docker will stop all running containers. Plan accordingly before proceeding.

### 6. Verify the Setup
You can verify the setup by accessing Grafana:

Open your browser and navigate to http://<YOUR_MONITORING_SERVER_IP>:3000.

Login with the default credentials:
Username: admin
Password: admin

### 7. Import Dashboards
   
The setup will not have pre-configured dashboards automatically. However, you can import some great dashboards for monitoring your environment:

Node Exporter Full: ID 1860
cAdvisor Exporter: ID 14282
Docker Monitoring: ID 15798

To import these dashboards:

Go to the Grafana dashboard.

Click on the "+" icon on the left side and choose "Import."
Enter the dashboard ID and click "Load."
Select the appropriate data source (Prometheus or Loki) and import the dashboard.

### Conclusion
This monitoring stack provides a flexible and powerful way to monitor and log metrics across multiple servers and containers. With Prometheus, Loki, and Grafana, you can easily scale and visualize your data in real time.

Future Enhancements
Alerting: Set up alerting rules in Prometheus and configure Alertmanager to receive notifications (email, Slack, etc.) when conditions are met.
Security: Secure the Grafana dashboard by configuring SSL, adding OAuth or LDAP authentication for access control.
Custom Dashboards: Customize Grafana dashboards to suit specific business metrics or infrastructure components.
