#!/bin/bash
aws ecs register-task-definition \
    --family catalogue \
    --network-mode awsvpc \
    --requires-compatibilities FARGATE \
    --cpu "256" \       # 0.25 vCPU
    --memory "512" \    # 512 MiB
    --execution-role-arn arn:aws:iam::806962169196:role/ecsTaskExecutionRole1 \
    --container-definitions '[
        {
            "name": "catalogue",
            "image": "siva9666/catalogue-instana:v1",
            "essential": true,
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
            "portMappings": [
                {
                    "containerPort": 8080,
                    "protocol": "tcp"
                }
            ],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/catalogue",
                    "awslogs-region": "ap-south-1",
                    "awslogs-stream-prefix": "ecs"
                }
            }
        }
    ]'
