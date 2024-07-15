# Compass VPN Manager

For collecting the metrics from CompassVPN agent(s), you can either use a free Grafana Cloud account or deploy a Prometheus Server+Pushgateway+Grafana using the instructions below.

## Option 1: Use Garafana Cloud

1. Create a new Grafana Cloud account: https://grafana.com/auth/sign-up/create-use
2. Login to your newly created account: https://\<your-username>\.grafana.net
3. Then go to the following page and create a new token (https://\<your-username\>.grafana.net/connections/add-new-connection/hmInstancePromId)
   ![2](https://github.com/user-attachments/assets/16d6eebf-a3f9-4abc-829d-98d895d07c4d)
4. We need "url", "username" and "password" from the previous step. 
   ![1](https://github.com/user-attachments/assets/7610c686-7bf8-46cc-ba20-7a3109f5f4e2)

In the agent .env file, use them as follows
   * GRAFANA_AGENT_REMOTE_WRITE_URL=\<url\>
   * GRAFANA_AGENT_REMOTE_WRITE_USER=\<username\>
   * GRAFANA_AGENT_REMOTE_WRITE_PASSWORD=\<password\>
5. Import the json dashboards from the dashboards folder into your Grafana.
6. Create a new VPS and follow [the installation guide](https://github.com/compassvpn/agent/blob/main/README.md#how-to-run) for installing the CompassVPN agent and set it up to send the metrics to your new Grafana Cloud.
7. After running an agent VPN server, you can see the data in the dashboards.
   ![3](https://github.com/user-attachments/assets/4b3686f7-4c07-4251-bc2d-a9a761c06af7)

Note: Once you have set up the first CompassVPN agent instance, for the rest of the servers, you can clone the agent repository and use the same .env_file that you created and run the ./bootstrap.sh to create VPN services and send metrics to the Grafana Cloud.

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
