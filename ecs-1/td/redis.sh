#!/bin/bash
aws ecs register-task-definition \
  --family redis \
  --network-mode bridge \
  --container-definitions '[{
    "name": "redis",
    "image": "siva9666/redis-instana:v1",
    "essential": true,
    "memory": 512,
    "portMappings": [{
      "containerPort": 6379,
      "hostPort": 6379
    }]
  }]'
