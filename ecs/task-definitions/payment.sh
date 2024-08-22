aws ecs register-task-definition \
    --family payment \
    --network-mode awsvpc \
    --container-definitions '[
        {
            "name": "payment",
            "image": "siva9666/payment-instana:v1",
            "memory": 512,
            "cpu": 256,
            "essential": true,
            "environment": [
                {
                    "name": "CART_HOST",
                    "value": "cart"
                },
                {
                    "name": "CART_PORT",
                    "value": "8080"
                },
                {
                    "name": "USER_HOST",
                    "value": "user"
                },
                {
                    "name": "USER_PORT",
                    "value": "8080"
                },
                {
                    "name": "AMQP_HOST",
                    "value": "rabbit"
                },
                {
                    "name": "AMQP_USER",
                    "value": "roboshop"
                },
                {
                    "name": "AMQP_PASS",
                    "value": "roboshop123"
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
