#!/bin/bash

# Define variables
region="ap-south-1"
cluster_name="roboshop"
services=("mongo" "rabbit" "redis" "catalogue" "cart" "dispatch" "payment" "shipping" "user" "web" "mysql")

# Loop through each service to create a log dashboard
for service in "${services[@]}"; do
  dashboard_name="${service}-log-dashboard"
  dashboard_body=$(cat <<EOF
{
  "widgets": [
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 24,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/Logs", "IncomingLogEvents", "LogGroupName", "/ecs/${service}" ]
        ],
        "view": "timeSeries",
        "stacked": false,
        "region": "${region}",
        "title": "${service} Log Events"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 6,
      "width": 24,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/Logs", "LogGroupSize", "LogGroupName", "/ecs/${service}" ]
        ],
        "view": "timeSeries",
        "stacked": false,
        "region": "${region}",
        "title": "${service} Log Group Size"
      }
    }
  ]
}
EOF
)
  aws cloudwatch put-dashboard --dashboard-name "${dashboard_name}" --dashboard-body "${dashboard_body}" --region "${region}"
done
