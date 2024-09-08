#!/bin/bash

# Get a list of all dashboards
dashboards=$(aws cloudwatch list-dashboards --query 'DashboardEntries[*].DashboardName' --output text)

# Loop through each dashboard and delete it
for dashboard in $dashboards; do
  echo "Deleting dashboard: $dashboard"
  aws cloudwatch delete-dashboards --dashboard-names "$dashboard"
done
