#!/bin/bash

CLUSTER_NAME="roboshop"        
SERVICE_NAME="debug-utility-service"  
CONTAINER_NAME="debug"         


TASK_IDS=$(aws ecs list-tasks --cluster $CLUSTER_NAME --service-name $SERVICE_NAME --query 'taskArns' --output text)

if [ -z "$TASK_IDS" ]; then
  echo "No tasks found for service $SERVICE_NAME."
  exit 1
fi

for TASK_ID in $TASK_IDS; do
  echo "Executing command on task $TASK_ID..."

  aws ecs execute-command \
      --cluster $CLUSTER_NAME \
      --task $TASK_ID \
      --container $CONTAINER_NAME \
      --interactive \
      --command "/bin/bash"
done
