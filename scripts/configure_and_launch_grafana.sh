#!/bin/bash

DEFAULT_GRAFANA_REST_ENDPOINT="http://admin:admin@localhost:3000"
DEFAULT_GRAFANA_VERSION=10.0.2
DEFAULT_PROMETHEUS_DATASOURCE="Prometheus"

# Mandatory
hazelcast_metrics_label=""
hazelcast_metrics_cluster_filter=""
prometheus_url=""

# Optional
grafana_version=""
grafana_rest_endpoint=""
prometheus_datasource=""

usage() {
   echo -e "Usage: $0
      \t\t-l <name of the label to apply the hazelcast cluster filter to>
      \t\t-f <hazelcast cluster filter>
      \t\t-u <prometheus url for grafana to read metrics from>
      \t\t[-e <grafana rest endpoint>]
      \t\t[-v <grafana version>]
      \t\t[-d <name of datasource in prometheus to be updated>]"
   exit 1
}

while getopts "l:f:u:e:d:v:" option; do
   case "${option}" in
      l)
         hazelcast_metrics_label="${OPTARG}"
         ;;
      f)
         hazelcast_metrics_cluster_filter="${OPTARG}"
         ;;
      u)
         prometheus_url=${OPTARG}
         ;;
      e)
         grafana_rest_endpoint=${OPTARG}
         ;;
      d)
         prometheus_datasource=${OPTARG}
         ;;
      v)
         grafana_version="${OPTARG}"
         ;;
      \?)
         usage
         ;;
   esac
done


if [ -z $hazelcast_metrics_label ] || [ -z $hazelcast_metrics_cluster_filter ]; then
   echo "both hazelcast metrics label and hazelcast metrics cluster filter must be provided"
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

if [ -z $grafana_version  ]; then
   echo "grafana version unspecified, using default"
   grafana_version=$DEFAULT_GRAFANA_VERSION
fi

./perform_grafana_setup.sh $hazelcast_metrics_label $hazelcast_metrics_cluster_filter $grafana_version

./update_prometheus_datasource.sh $grafana_rest_endpoint $prometheus_datasource $prometheus_url

echo "successfully configured and launched grafana with prometheus datasource, showing grafana log..."
tail -f /opt/padogrid/workspaces/myrwe/myws/apps/grafana/log/grafana.log