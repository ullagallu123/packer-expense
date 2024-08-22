aws ecs register-task-definition \
    --family catalogue \
    --network-mode awsvpc \
    --container-definitions '[
        {
            "name": "catalogue",
            "image": "siva9666/catalogue-instana:v1",
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
                    "value": "mongodb://mongo:27017/catalogue"
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
