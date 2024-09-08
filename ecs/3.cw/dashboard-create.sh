#!/bin/bash

# Define variables
region="ap-south-1"
cluster_name="roboshop"
services=("mongo" "rabbit" "redis" "catalogue" "cart" "dispatch" "payment" "shipping" "user" "web" "mysql")

# Loop through each service
for service in "${services[@]}"; do
  dashboard_name="${service}-service-dashboard"
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
          [ "AWS/ECS", "CPUUtilization", "ClusterName", "${cluster_name}", "ServiceName", "${service}-service" ],
          [ ".", "MemoryUtilization", ".", ".", ".", "." ]
        ],
        "view": "timeSeries",
        "stacked": false,
        "region": "${region}",
        "title": "${service} Service Metrics"
      }
    }
  ]
}
EOF
)
  aws cloudwatch put-dashboard --dashboard-name "${dashboard_name}" --dashboard-body "${dashboard_body}" --region "${region}"
done
