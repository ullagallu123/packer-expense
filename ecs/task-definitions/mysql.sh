#!/bin/bash
aws ecs register-task-definition \
    --family mysql \
    --network-mode awsvpc \
    --requires-compatibilities FARGATE \
    --cpu "500" \
    --memory "1024" \
    --execution-role-arn arn:aws:iam::427366301535:role/ecsTaskExecutionRole1 \
    --container-definitions '[
        {
            "name": "mysql",
            "image": "siva9666/mysql-instana:v1",
            "essential": true,
            "linuxParameters": {
                "initProcessEnabled": true
            },
            "environment": [
                {
                    "name": "MYSQL_ROOT_PASSWORD",
                    "value": "RoboShop@1"
                }
            ],
            "portMappings": [
                {
                    "containerPort": 3306,
                    "protocol": "tcp"
                }
            ],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/mysql",
                    "awslogs-region": "ap-south-1",
                    "awslogs-stream-prefix": "ecs"
                }
            }
        }
    ]'
