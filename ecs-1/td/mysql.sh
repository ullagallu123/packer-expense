#!/bin/bash
aws ecs register-task-definition \
  --family mysql \
  --network-mode bridge \
  --container-definitions '[{
    "name": "mysql",
    "image": "siva9666/mysql-instana:v1",
    "essential": true,
    "memory": 512,
    "environment": [
      {
        "name": "MYSQL_ROOT_PASSWORD",
        "value": "RoboShop@1"
      }
    ],
    "portMappings": [{
      "containerPort": 3306,
      "hostPort": 3306
    }]
  }]'
