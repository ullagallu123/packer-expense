#!/bin/bash
aws ecs register-task-definition \
    --family dispatch \
    --network-mode awsvpc \
    --requires-compatibilities FARGATE \
    --cpu "256" \
    --memory "512" \
    --execution-role-arn arn:aws:iam::427366301535:role/ecsTaskExecutionRole1 \
    --container-definitions '[
        {
            "name": "dispatch",
            "image": "siva9666/dispatch-instana:v1",
            "essential": true,
            "environment": [
                {
                    "name": "AMQP_HOST",
                    "value": "rabbit.instana"
                },
                {
                    "name": "AMQP_USER",
                    "value": "roboshop"
                },
                {
                    "name": "AMQP_PASS",
                    "value": "roboshop123"
                }
            ],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/dispatch",
                    "awslogs-region": "ap-south-1",
                    "awslogs-stream-prefix": "ecs"
                }
            }
        }
    ]'
