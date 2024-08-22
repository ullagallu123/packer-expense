aws ecs register-task-definition \
    --family mongo \
    --network-mode awsvpc \
    --container-definitions '[
        {
            "name": "mongo",
            "image": "siva9666/mongo-instana:v1",
            "memory": 512,
            "cpu": 256,
            "essential": true,
            "portMappings": [
                {
                    "containerPort": 27017,
                    "protocol": "tcp"
                }
            ]
        }
    ]'
