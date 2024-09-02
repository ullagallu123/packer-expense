#!/bin/bash
aws ecs register-task-definition \
    --family debug-utility \
    --network-mode awsvpc \
    --requires-compatibilities FARGATE \
    --cpu "256" \
    --memory "512" \
    --execution-role-arn arn:aws:iam::806962169196:role/ecsTaskExecutionRole1 \
    --task-role-arn arn:aws:iam::806962169196:role/ecsTaskExecutionRole1 \
    --container-definitions '[
        {
            "name": "debug",
            "image": "siva9666/debug-utility:v1",
            "essential": true,
            "command": ["/bin/bash", "-c", "while true; do echo Running; sleep 3600; done"],
            "portMappings": [],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/debug-utility",
                    "awslogs-region": "ap-south-1",
                    "awslogs-stream-prefix": "ecs"
                }
            }
        }
    ]'

