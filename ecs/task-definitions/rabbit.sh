aws ecs register-task-definition \
    --family rabbit \
    --network-mode awsvpc \
    --container-definitions '[
        {
            "name": "rabbit",
            "image": "siva9666/rabbit-instana:v1",
            "memory": 512,
            "cpu": 256,
            "essential": true,
            "portMappings": [
                {
                    "containerPort": 5671,
                    "protocol": "tcp"
                }
            ]
        }
    ]'
