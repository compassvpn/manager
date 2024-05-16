# Compass VPN Manager

For collecting the metrics from Compass Agent(s), you can either use a free Grafana Cloud account or deploy a Prometheus Server+Pushgateway+Grafana using the the instruction below.

## Option 1: Use Garafana Cloud

1. Create a new Grafana Cloud account: https://grafana.com/auth/sign-up/create-use
2. Login to your newly created account: https://\<your-username>\.grafana.net
3. Then go to the data sources page and find the "grafanacloud-prom" data source (https://\<your-username\>.grafana.net/connections/datasources/edit/grafanacloud-prom)
4. We need "Prometheus server URL", "User" and "Password" from this page. In the agent .env file, use them as follows
   * GRAFANA_AGENT_REMOTE_WRITE_URL=\<Prometheus server URL\>
   * GRAFANA_AGENT_REMOTE_WRITE_USER=\<User\>
   * GRAFANA_AGENT_REMOTE_WRITE_PASSWORD=\<Password\>
5. Import the json dashboards from the dashboards folder into your Grafana.
6. Spin up a new CompassVPN agent and set it up to send the metrics to your new Grafana Cloud.

## Option 2: Deploy your own server

### Prometheus Server
We use Prometheus to collect all configs and logs of the agents.

### Prometheus Pushgateway
All agents push their metrics and vpn configs to pushgateway to be added to the Prometheus.

### Grafana
Use Prometheus as data source and visualize the metrics.

#### How to Install

Make sure that you have a running Kubernetes cluster and you can retrieve the list of nodes using the following:
```
kubectl get nodes
```

#### Add Helm Chart Repos
```
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
```

## Create passwd file for basic auth for Prometheus pushgateway
```
htpasswd -c auth <user>
```

#### Create secret
```
kubectl create secret generic basic-auth --from-file=auth
```

#### Install Prometheus Helm Chart
```
cd prometheus/
helm install prometheus prometheus-community/prometheus -f values.yaml
```

#### Install Grafana Helm Chart
```
cd grafana/
helm install grafana grafana/grafana -f values.yaml
```

#### Install NGINX Ingress Controller
```
cd nginx-ingress-controller/
helm install nginx-ingress-controller oci://registry-1.docker.io/bitnamicharts/nginx-ingress-controller -f values.yaml
```
