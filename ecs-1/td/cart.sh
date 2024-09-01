aws ecs register-task-definition \
  --family cart \
  --network-mode bridge \
  --container-definitions '[{
    "name": "cart",
    "image": "siva9666/cart-instana:v1",
    "essential": true,
    "memory": 512,
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
    "portMappings": [{
      "containerPort": 8080,
      "hostPort": 8080
    }]
  }]'
