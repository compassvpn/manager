# Compass VPN Manager

For collecting the metrics from CompassVPN agent(s), you can either use a free Grafana Cloud account or deploy a Prometheus Server+Pushgateway+Grafana using the instructions below. Choose the option that best suits your needs based on your infrastructure and requirements. Option 1 _(Grafana Cloud)_ is reccomended for simplicity.

### Read the complete guide [on our website](https://www.compassvpn.org/installation/manager-setup/).

---


## Option 1: Grafana Cloud

Grafana Cloud offers a free tier that is sufficient for monitoring several CompassVPN agents. This is recommended for its simplicity.
### Follow [this tutorial](https://www.compassvpn.org/installation/manager-setup/#option-1-grafana-cloud) to setup Grafana cloud.

## Option 2: Pushgateway

This option gives you complete control over your monitoring stack but requires a Kubernetes cluster and more setup.
### Follow [this tutorial](https://www.compassvpn.org/installation/manager-setup/#option-2-self-hosted-kubernetes-deployment) to setup Pushgateway.


## Import Dashboards

The CompassVPN dashboard is available [here](https://grafana.com/grafana/dashboards/23181-compassvpn-dashboard/). To import it into your Grafana instance:

1.  Navigate to **Dashboards** > **Import** in your Grafana UI.
2.  Enter the dashboard ID `23181`.
3.  Select your Prometheus data source when prompted.
4.  Click **Import**.
