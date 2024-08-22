aws ecs register-task-definition \
    --family dispatch \
    --network-mode awsvpc \
    --container-definitions '[
        {
            "name": "dispatch",
            "image": "siva9666/dispatch-instana:v1",
            "memory": 512,
            "cpu": 256,
            "essential": true,
            "environment": [
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
            ]
        }
    ]'
