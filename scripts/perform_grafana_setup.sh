#!/bin/bash

perform_grafana_product_update() {

   local version=$1
   local update_products_command="update_products -product grafana -version $version"

   execute_command "$update_products_command"

}

perform_switch_workspace() {

   execute_command "switch_workspace"

}

perform_create_app() {

   execute_command "create_app -product hazelcast -app grafana"

}

perform_switch_to_app_dir() {

   execute_command "cd /opt/padogrid/workspaces/myrwe/myws/apps/grafana/bin_sh"
   echo "current working directory: $(pwd)"

}

perform_start_grafana() {

   execute_command "./start_grafana"

   echo "entering grafana readiness wait loop"
   until curl --output /dev/null --silent --head --fail http://localhost:3000; do
      printf '.'
      sleep 3
   done
   echo -e "\ngrafana achieved readiness, commencing..."

}

perform_cluster_template_update() {

   local label=$1
   local hazelcast_cluster_name=$2

   update_cluster_command="./update_cluster_templating -label $label -cluster $hazelcast_cluster_name"
   execute_command "$update_cluster_command"

}

perform_folder_import() {

   execute_command "./import_folder -f Hazelcast"

}

execute_command() {

   local cmd=$1
   echo "Command to run: $cmd"
   eval "$cmd"
   echo

}

hazelcast_metrics_label=$1
hazelcast_metrics_cluster_filter=$2
grafana_version=$3

echo "hazelcast metrics label: $hazelcast_metrics_label"
echo "hazelcast metrics cluster filter: $hazelcast_metrics_cluster_filter"
echo "grafana version: $grafana_version"

perform_grafana_product_update $grafana_version

perform_switch_workspace

perform_create_app

perform_switch_to_app_dir

perform_start_grafana

perform_cluster_template_update $hazelcast_metrics_label $hazelcast_metrics_cluster_filter

perform_folder_import
