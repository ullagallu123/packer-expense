aws ecs register-task-definition \
    --family web \
    --network-mode awsvpc \
    --requires-compatibilities FARGATE \
    --cpu "256" \       # 0.25 vCPU
    --memory "512" \    # 512 MiB
    --execution-role-arn arn:aws:iam::806962169196:role/ecsTaskExecutionRole1 \
    --container-definitions '[
        {
            "name": "web",
            "image": "siva9666/web-instana:v2",
            "essential": true,
            "portMappings": [
                {
                    "containerPort": 80,
                    "protocol": "tcp"
                }
            ],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/web",
                    "awslogs-region": "ap-south-1",
                    "awslogs-stream-prefix": "ecs"
                }
            }
        }
    ]'
