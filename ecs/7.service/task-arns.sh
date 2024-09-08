#!/bin/bash

CLUSTER_NAME="roboshop"        
SERVICE_NAME="debug-utility-service"  
CONTAINER_NAME="debug"         

# List tasks for the specified service
TASK_IDS=$(aws ecs list-tasks --cluster $CLUSTER_NAME --service-name $SERVICE_NAME --query 'taskArns' --output text)

echo "Tasks found: $TASK_IDS"

if [ -z "$TASK_IDS" ]; then
  echo "No tasks found for service $SERVICE_NAME."
  exit 1
fi

for TASK_ID in $TASK_IDS; do
  echo "Executing command on task $TASK_ID..."

  # Execute command in the specified container
  aws ecs execute-command \
      --cluster $CLUSTER_NAME \
      --task $TASK_ID \
      --container $CONTAINER_NAME \
      --interactive \
      --command "/bin/bash"

  if [ $? -ne 0 ]; then
    echo "Failed to execute command on task $TASK_ID."
  else
    echo "Command executed successfully on task $TASK_ID."
  fi
done
