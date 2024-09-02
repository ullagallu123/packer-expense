#!/bin/bash
aws ecs create-service \
    --cluster roboshop \
    --service-name redis-service \
    --task-definition redis \
    --desired-count 1 \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[subnet-0731498b80aa56290],securityGroups=[sg-00c0933258e06cea0],assignPublicIp=ENABLED}" \
    --service-registries "registryArn=arn:aws:servicediscovery:ap-south-1:8069-6216-9196:service/srv-62vkm352txfipy4t"