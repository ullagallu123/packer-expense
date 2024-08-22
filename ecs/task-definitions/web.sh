aws ecs register-task-definition \
    --family web \
    --network-mode awsvpc \
    --container-definitions '[
        {
            "name": "web",
            "image": "siva9666/web-instana:v2",
            "memory": 512,
            "cpu": 256,
            "essential": true,
            "portMappings": [
                {
                    "containerPort": 80,
                    "protocol": "tcp"
                }
            ]
        }
    ]'
