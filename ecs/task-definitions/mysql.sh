aws ecs register-task-definition \
    --family mysql \
    --network-mode awsvpc \
    --container-definitions '[
        {
            "name": "mysql",
            "image": "siva9666/mysql-instana:v1",
            "memory": 512,
            "cpu": 256,
            "essential": true,
            "environment": [
                {
                    "name": "MYSQL_ROOT_PASSWORD",
                    "value": "RoboShop@1"
                }
            ],
            "portMappings": [
                {
                    "containerPort": 3306,
                    "protocol": "tcp"
                }
            ]
        }
    ]'
