#!/bin/bash

# List all services and extract their IDs
service_ids=$(aws servicediscovery list-services --query "Services[*].Id" --output text)

# Check if there are any services to delete
if [ -z "$service_ids" ]; then
  echo "No services found."
  exit 0
fi

# Loop through each service ID and delete it
for service_id in $service_ids; do
  echo "Deleting service with ID: $service_id"
  aws servicediscovery delete-service --id "$service_id"
done

echo "All services have been deleted."
