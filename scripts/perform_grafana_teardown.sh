#!/bin/bash

if [ -f "./stop_grafana" ]; then
  echo "Script to perform Grafana teardown present in '$PWD', executing..."
  eval "./stop_grafana"
else
  echo "Script to perform Grafana teardown not present in '$PWD', attempting to identify matching process..."
  eval "ps aux | grep \"grafana server -config\" | grep -v grep | awk '{print $2}' | xargs kill -15"
fi

