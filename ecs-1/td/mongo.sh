#!/bin/bash
aws ecs register-task-definition \
  --family mongo \
  --network-mode bridge \
  --container-definitions '[{
    "name": "mongo",
    "image": "siva9666/mongo-instana:v1",
    "essential": true,
    "memory": 512,
    "portMappings": [{
      "containerPort": 27017,
      "hostPort": 27017
    }]
  }]'
