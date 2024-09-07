#!/bin/bash
aws ecs register-task-definition \
    --family cart \
    --network-mode awsvpc \
    --requires-compatibilities FARGATE \
    --cpu "256" \
    --memory "512" \
    --execution-role-arn arn:aws:iam::427366301535:role/ecsTaskExecutionRole1 \
    --container-definitions '[
        {
            "name": "cart",
            "image": "siva9666/cart-instana:v1",
            "essential": true,
            "environment": [
                {
                    "name": "CATALOGUE_HOST",
                    "value": "catalogue.instana"
                },
                {
                    "name": "CATALOGUE_PORT",
                    "value": "8080"
                },
                {
                    "name": "REDIS_HOST",
                    "value": "redis.instana"
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
                    "awslogs-group": "/ecs/cart",
                    "awslogs-region": "ap-south-1",
                    "awslogs-stream-prefix": "ecs"
                }
            }
        }
    ]'
