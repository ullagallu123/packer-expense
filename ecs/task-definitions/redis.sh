aws ecs register-task-definition \
    --family redis \
    --network-mode awsvpc \
    --container-definitions '[
        {
            "name": "redis",
            "image": "siva9666/redis-instana:v1",
            "memory": 512,
            "cpu": 256,
            "essential": true,
            "portMappings": [
                {
                    "containerPort": 6379,
                    "protocol": "tcp"
                }
            ]
        }
    ]'
