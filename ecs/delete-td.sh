#!/bin/bash

# Fetch all task definition ARNs
task_definitions=$(aws ecs list-task-definitions --query 'taskDefinitionArns[*]' --output text)

# Loop through each task definition and deregister it
for task_definition in $task_definitions
do
  echo "Deregistering task definition: $task_definition"
  aws ecs deregister-task-definition --task-definition $task_definition
done

echo "All task definitions have been deregistered."
