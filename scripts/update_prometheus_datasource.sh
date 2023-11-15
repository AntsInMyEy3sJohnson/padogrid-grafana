#!/bin/bash

DEFAULT_GRAFANA_REST_ENDPOINT="http://admin:admin@localhost:3000"
DEFAULT_PROMETHEUS_DATASOURCE="Prometheus"

grafana_rest_endpoint=$1
prometheus_datasource=$2
prometheus_url=$3

echo "querying uid of datasource from grafana"
uid=$(curl -sS -X GET $grafana_rest_endpoint/api/datasources | jq '.[].uid')
uid_unquoted=$(echo $uid | sed 's/^"//;s/"$//')

echo "modifying datasource with uid '$uid_unquoted'"

curl -sS -X PUT $grafana_rest_endpoint/api/datasources/uid/$uid_unquoted -H "Content-Type: application/json" -d '{"name": "'"$prometheus_datasource"'", "type": "prometheus", "access": "proxy", "url": "'"$prometheus_url"'", "jsonData": {"tlsSkipVerify": true}}' | jq .
