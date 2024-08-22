aws ecs register-task-definition \
    --family cart \
    --network-mode awsvpc \
    --container-definitions '[
        {
            "name": "cart",
            "image": "siva9666/cart-instana:v1",
            "memory": 512,
            "cpu": 256,
            "essential": true,
            "environment": [
                {
                    "name": "CATALOGUE_HOST",
                    "value": "catalogue"
                },
                {
                    "name": "CATALOGUE_PORT",
                    "value": "8080"
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
