#!/bin/bash
aws ecs create-service \
    --cluster roboshop \
    --service-name cart-service \
    --task-definition cart \
    --desired-count 1 \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[subnet-090cf41d5e0cdf437],securityGroups=[sg-0ca8167841704f04d],assignPublicIp=ENABLED}" \
    --service-registries "registryArn=arn:aws:servicediscovery:ap-south-1:4273-6630-1535:service/srv-pd3oigwz37gqv3x7"