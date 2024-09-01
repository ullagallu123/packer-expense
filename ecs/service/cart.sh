#!/bin/bash
aws ecs create-service \
    --cluster instana \
    --service-name cart-service \
    --task-definition cart \
    --desired-count 1 \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[subnet-0731498b80aa56290],securityGroups=[sg-00c0933258e06cea0],assignPublicIp=ENABLED}" \
    --service-registries "registryArn=arn:aws:servicediscovery:ap-south-1:8069-6216-9196:service/srv-44o77euxjge6opr5"