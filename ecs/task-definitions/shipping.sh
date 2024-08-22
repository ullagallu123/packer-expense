aws ecs register-task-definition \
    --family shipping \
    --network-mode awsvpc \
    --container-definitions '[
        {
            "name": "shipping",
            "image": "siva9666/shipping-instana:v1",
            "memory": 512,
            "cpu": 256,
            "essential": true,
            "environment": [
                {
                    "name": "DB_HOST",
                    "value": "mysql"
                },
                {
                    "name": "DB_PORT",
                    "value": "3306"
                },
                {
                    "name": "DB_USER",
                    "value": "shipping"
                },
                {
                    "name": "DB_PASSWD",
                    "value": "RoboShop@1"
                },
                {
                    "name": "CART_ENDPOINT",
                    "value": "cart:8080"
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
