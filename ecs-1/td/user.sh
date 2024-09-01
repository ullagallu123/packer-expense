#!/bin/bash
aws ecs register-task-definition \
  --family user \
  --network-mode bridge \
  --container-definitions '[{
    "name": "user",
    "image": "siva9666/user-instana:v1",
    "essential": true,
    "memory": 512,
    "environment": [
      {
        "name": "MONGO",
        "value": "true"
      },
      {
        "name": "MONGO_URL",
        "value": "mongodb://mongo:27017/users"
      },
      {
        "name": "REDIS_HOST",
        "value": "redis"
      }
    ],
    "portMappings": [{
      "containerPort": 8080,
      "hostPort": 8080
    }]
  }]'
