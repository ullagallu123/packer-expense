#!/bin/bash

# Define variables
region="ap-south-1"
services=("mongo" "rabbit" "redis" "catalogue" "cart" "dispatch" "payment" "shipping" "user" "web" "mysql")

# Define dashboard name
dashboard_name="All-Services-Log-Dashboard"

# Initialize widgets array
widgets="["

# Loop through each service to create a placeholder text widget
for i in "${!services[@]}"; do
  service="${services[$i]}"
  
  widget=$(cat <<EOF
    {
      "type": "text",
      "x": $(($i % 2 * 12)),
      "y": $(($i / 2 * 6)),
      "width": 12,
      "height": 6,
      "properties": {
        "markdown": "### ${service} Logs\nLog widget for ${service} service."
      }
    }
EOF
)

  # Append the widget to the widgets array
  if [ $i -ne 0 ]; then
    widgets+=","
  fi
  widgets+="$widget"
done

# Close the widgets array
widgets+="]"

# Create the dashboard JSON payload
dashboard_body=$(cat <<EOF
{
  "widgets": $widgets
}
EOF
)

# Create or update the CloudWatch dashboard
echo "Creating or updating dashboard: ${dashboard_name}"
aws cloudwatch put-dashboard --dashboard-name "${dashboard_name}" --dashboard-body "${dashboard_body}" --region "${region}"
