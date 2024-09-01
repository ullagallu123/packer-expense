aws ecs register-task-definition \
  --family rabbit \
  --network-mode bridge \
  --container-definitions '[{
    "name": "rabbit",
    "image": "siva9666/rabbit-instana:v1",
    "essential": true,
    "memory": 512,
    "portMappings": [{
      "containerPort": 5672,
      "hostPort": 5672
    }]
  }]'
