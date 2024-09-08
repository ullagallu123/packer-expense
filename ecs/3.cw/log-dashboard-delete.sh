#!/bin/bash

# Define the region
region="ap-south-1"

# List all dashboards and extract their names
dashboard_names=$(aws cloudwatch list-dashboards --region ${region} --query "DashboardEntries[*].DashboardName" --output text)

# Loop through each dashboard name and delete it
for dashboard_name in ${dashboard_names}; do
  if [[ $dashboard_name == *"-log-dashboard" ]]; then
    echo "Deleting dashboard: ${dashboard_name}"
    aws cloudwatch delete-dashboards --dashboard-names "${dashboard_name}" --region ${region}
  fi
done

