#!/bin/bash

# List all services in the cluster
services=$(aws ecs list-services --cluster roboshop --query "serviceArns[]" --output text)

# Loop through each service and delete it
for service in $services; do
    echo "Deleting service: $service"
    aws ecs delete-service --cluster instana --service "$service" --force
done
