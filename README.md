# Compass VPN Manager

For collecting the metrics from CompassVPN agent(s), you can either use a free Grafana Cloud account or deploy a Prometheus Server+Pushgateway+Grafana using the instructions below. Choose the option that best suits your needs based on your infrastructure and requirements. Option 1 _(Grafana Cloud)_ is reccomended for simplicity.

### Read the comprehensive guide on our website: https://www.compassvpn.org/installation/manager-setup/

---


## Option 1: Grafana Cloud

Grafana Cloud offers a free tier that is sufficient for monitoring several CompassVPN agents.

### Step 1: Create a Grafana Cloud Account

1. Go to [Grafana Cloud](https://grafana.com/auth/sign-up/create-user) and sign up for a free account
2. Verify your email address and complete the registration process

### Step 2: Create a New Connection

1. After creating your account, go to the following URL _(replace `<your-username>` with your actual Grafana Cloud username)_:
   ```plaintext
   https://<your-username>.grafana.net/connections/add-new-connection/hmInstancePromId
   ```

2. Create a new token as shown in the image below:
   ![Grafana Cloud screen prompting the user to create a new connection token](https://github.com/user-attachments/assets/020949ea-7a58-4acd-a843-a9d737aa24b7)
   *Figure 1: Creating a new connection token in Grafana Cloud.*

4. After creating the token, you'll see three credentials as shown below:
   ![Grafana Cloud screen displaying the generated URL, username, and password credentials](https://github.com/user-attachments/assets/7e62690b-3b82-43f8-a6bc-b27ffffbe0a1)
   *Figure 2: Copying the URL, username, and password credentials for agent configuration.*

6. Copy these three credentials:
   - URL
   - Username
   - Password
   
   These will be used in your agent configuration.

### Step 3: Configure CompassVPN Agent

Open the `env_file` on your VPN server and set the following variables:

```shell
METRIC_PUSH_METHOD=grafana_cloud
GRAFANA_AGENT_REMOTE_WRITE_URL=<url>
GRAFANA_AGENT_REMOTE_WRITE_USER=<username>
GRAFANA_AGENT_REMOTE_WRITE_PASSWORD=<password>
```

Replace:
- `<url>` with the URL you copied
- `<username>` with the username you copied
- `<password>` with the password you copied

For more details on these configuration parameters, see the [Configuration Guide](https://www.compassvpn.org/installation/configuration/).

### Step 4: Import Dashboards

1. In Grafana Cloud, navigate to **Dashboards** in the left sidebar
2. Click the **Import** button
3. Use the following dashboard ID:
   - **`23181`** for CompassVPN Dashboard
4. Set your prometheus data source

   > Note: Dashboard page is available [here](https://grafana.com/grafana/dashboards/23181).

## Option 2: Self-hosted Kubernetes Deployment

This option gives you complete control over your monitoring stack but requires a Kubernetes cluster and more setup.

### Repository Structure

The CompassVPN manager repository contains the following key components:

- `prometheus/` - Helm chart values for Prometheus
- `grafana/` - Helm chart values for Grafana
- `nginx-ingress-controller/` - Helm chart values for NGINX Ingress
- `create_auth.sh` - Script to create basic authentication credentials
- `auth.example` - Example authentication file
- `users.txt.example` - Example users file

### Step 1: Set Up a Kubernetes Cluster

Ensure you have a running Kubernetes cluster and can retrieve the list of nodes:

```bash
kubectl get nodes
```

### Step 2: Add Required Helm Chart Repositories

```bash
helm repo add grafana https://grafana.github.io/helm-charts
```
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
```

### Step 3: Create Authentication for Prometheus Pushgateway

1. Create a basic authentication file using the provided script or manually:

```bash
# Create auth file using the script
./create_auth.sh

# Or manually create it
htpasswd -c auth <username>
```

2. Create a Kubernetes secret from the authentication file:

```bash
kubectl create secret generic basic-auth --from-file=auth
```

You can refer to `auth.example` and `users.txt.example` in the repository for reference formats.

### Step 4: Install Prometheus

Navigate to the prometheus directory and install using Helm:

```bash
cd prometheus/
helm install prometheus prometheus-community/prometheus -f values.yaml
```

### Step 5: Install Grafana

Navigate to the grafana directory and install using Helm:

```bash
cd grafana/
```
```bash
helm install grafana grafana/grafana -f values.yaml
```

### Step 6: Install NGINX Ingress Controller

Navigate to the nginx-ingress-controller directory and install using Helm:

```bash
cd nginx-ingress-controller/
```
```bash
helm install nginx-ingress-controller oci://registry-1.docker.io/bitnamicharts/nginx-ingress-controller -f values.yaml
```

### Step 7: Configure CompassVPN Agent

Open the `env_file` on your VPN server and set the following variables:

```bash
METRIC_PUSH_METHOD=pushgateway
PUSHGATEWAY_URL=http://your-ingress-domain.com
PUSHGATEWAY_AUTH_USER=your_username
PUSHGATEWAY_AUTH_PASSWORD=your_password
```

Replace:
- `your-ingress-domain.com` with your configured ingress domain
- `your_username` and `your_password` with the credentials you created

### Step 8: Import Dashboards in Grafana

1. Access Grafana at your configured ingress URL
2. Log in with your Grafana credentials _(check the Grafana Helm values for default credentials)_
3. Import the JSON dashboards:
   - Navigate to **Dashboards** > **Import**
   - Use dashboard ID `23181`
   - Select your Prometheus data source
   - Click **Import**
