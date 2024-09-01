#!/bin/bash
aws ecs register-task-definition \
  --family catalogue \
  --network-mode bridge \
  --container-definitions '[{
    "name": "catalogue",
    "image": "siva9666/catalogue-instana:v1",
    "essential": true,
    "memory": 512,
    "environment": [
      {
        "name": "MONGO",
        "value": "true"
      },
      {
        "name": "MONGO_URL",
        "value": "mongodb://mongo:27017/catalogue"
      }
    ],
    "portMappings": [{
      "containerPort": 8080,
      "hostPort": 8080
    }]
  }]'
