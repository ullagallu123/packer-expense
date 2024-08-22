#!/bin/bash
aws ecs register-task-definition \
    --family payment \
    --network-mode awsvpc \
    --requires-compatibilities FARGATE \
    --cpu "256" \      
    --memory "512" \    
    --execution-role-arn arn:aws:iam::806962169196:role/ecsTaskExecutionRole1 \
    --container-definitions '[
        {
            "name": "payment",
            "image": "siva9666/payment-instana:v1",
            "essential": true,
            "environment": [
                {
                    "name": "CART_HOST",
                    "value": "cart"
                },
                {
                    "name": "CART_PORT",
                    "value": "8080"
                },
                {
                    "name": "USER_HOST",
                    "value": "user"
                },
                {
                    "name": "USER_PORT",
                    "value": "8080"
                },
                {
                    "name": "AMQP_HOST",
                    "value": "rabbit"
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
            "portMappings": [
                {
                    "containerPort": 8080,
                    "protocol": "tcp"
                }
            ],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/payment",
                    "awslogs-region": "ap-south-1",
                    "awslogs-stream-prefix": "ecs"
                }
            }
        }
    ]'
