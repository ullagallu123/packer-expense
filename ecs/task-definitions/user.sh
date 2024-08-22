aws ecs register-task-definition \
    --family user \
    --network-mode awsvpc \
    --container-definitions '[
        {
            "name": "user",
            "image": "siva9666/user-instana:v1",
            "memory": 512,
            "cpu": 256,
            "essential": true,
            "environment": [
                {
                    "name": "MONGO",
                    "value": "true"
                },
                {
                    "name": "MONGO_URL",
                    "value": "mongodb://mongo:27017/users"
                },
                {
                    "name": "REDIS_HOST",
                    "value": "redis"
                }
            ],
            "portMappings": [
                {
                    "containerPort": 8080,
                    "protocol": "tcp"
                }
            ]
        }
    ]'
