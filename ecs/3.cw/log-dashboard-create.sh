#!/bin/bash

# Define variables
region="ap-south-1"
services=("mongo" "rabbit" "redis" "catalogue" "cart" "dispatch" "payment" "shipping" "user" "web" "mysql")

# Loop through each service to create a log insights dashboard
for service in "${services[@]}"; do
  dashboard_name="${service}-log-dashboard"
  dashboard_body=$(cat <<EOF
{
  "widgets": [
    {
      "type": "query",
      "x": 0,
      "y": 0,
      "width": 24,
      "height": 6,
      "properties": {
        "view": "log",
        "region": "${region}",
        "query": "fields @timestamp, @message | stats count() as logCount by bin(1h)",
        "logGroupNames": ["/ecs/${service}"],
        "title": "${service} All Logs",
        "stacked": false
      }
    }
  ]
}
EOF
)
  aws cloudwatch put-dashboard --dashboard-name "${dashboard_name}" --dashboard-body "${dashboard_body}" --region "${region}"
done
