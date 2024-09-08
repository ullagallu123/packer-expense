#!/bin/bash
CLUSTER_NAME="roboshop"

# List and delete services
SERVICES=$(aws ecs list-services --cluster $CLUSTER_NAME --query 'serviceArns' --output text)
for SERVICE in $SERVICES; do
    aws ecs delete-service --cluster $CLUSTER_NAME --service $SERVICE
    echo "Deleted service: $SERVICE"
done

# List and stop tasks
TASKS=$(aws ecs list-tasks --cluster $CLUSTER_NAME --query 'taskArns' --output text)
for TASK in $TASKS; do
    aws ecs stop-task --cluster $CLUSTER_NAME --task $TASK
    echo "Stopped task: $TASK"
done

# Delete the cluster
aws ecs delete-cluster --cluster $CLUSTER_NAME
echo "Deleted cluster: $CLUSTER_NAME"
