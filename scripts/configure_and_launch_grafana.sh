#!/bin/bash

DEFAULT_GRAFANA_REST_ENDPOINT="http://admin:admin@localhost:3000"
DEFAULT_GRAFANA_VERSION=10.2.3
DEFAULT_PROMETHEUS_DATASOURCE="Prometheus"

# Mandatory
hazelcast_metrics_label=$PADO_MONITORING_HAZELCAST_METRICS_LABEL
prometheus_url=$PADO_MONITORING_PROMETHEUS_URL

# Optional
grafana_version=$PADO_MONITORING_GRAFANA_VERSION
grafana_rest_endpoint=$PADO_MONITORING_GRAFANA_REST_ENDPOINT
prometheus_datasource=$PADO_MONITORING_PROMETHEUS_DATASOURCE

handle_termination_signal() {
  echo "Caught termination signal, terminating Grafana..."
  ./perform_grafana_teardown.sh
  exit 0
}

trap 'handle_termination_signal' SIGTERM SIGINT

usage() {
   echo -e "Usage: $0
      \tThe script reads the following environment variables:
      \tPADO_MONITORING_HAZELCAST_METRICS_LABEL (mandatory): name of the label to apply the hazelcast cluster filter to 
      \tPADO_MONITORING_PROMETHEUS_URL (mandatory): prometheus url for grafana to read metrics from
      \tPADO_MONITORING_GRAFANA_VERSION (optional): grafana version (default: 10.2.0)
      \tPADO_MONITORING_GRAFANA_VERSION (optional): grafana rest endpoint (default: localhost:3000)
      \tPADO_MONITORING_PROMETHEUS_DATASOURCE (optional): name of datasource in prometheus to be updated (default: Prometheus)"
   exit 1
}

if [ -z "$hazelcast_metrics_label" ]; then
   echo "hazelcast metrics label must be defined"
   usage
   exit 1
fi

if [ -z "$prometheus_url" ]; then
   echo "prometheus url must be specified"
   exit 1
fi

if [ -z "$prometheus_datasource" ];  then
   echo "prometheus datasource unspecified -- using default"
   prometheus_datasource=$DEFAULT_PROMETHEUS_DATASOURCE
fi

if [ -z "$grafana_rest_endpoint" ]; then
   echo "grafana rest endpoint unspecified -- using default"
   grafana_rest_endpoint=$DEFAULT_GRAFANA_REST_ENDPOINT
fi

if [ -z "$grafana_version"  ]; then
   echo "grafana version unspecified, using default"
   grafana_version=$DEFAULT_GRAFANA_VERSION
fi

./perform_grafana_setup.sh "$hazelcast_metrics_label" "$grafana_version"

./update_prometheus_datasource.sh "$grafana_rest_endpoint" "$prometheus_datasource" "$prometheus_url"

echo -e "\nsuccessfully configured and launched grafana with prometheus datasource, entering tail for grafana log...\n"

tail -f /opt/padogrid/workspaces/myrwe/myws/apps/grafana/log/grafana.log
