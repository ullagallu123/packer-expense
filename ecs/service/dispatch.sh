#!/bin/bash
aws ecs create-service \
    --cluster roboshop \
    --service-name dispatch-service \
    --task-definition dispatch \
    --desired-count 1 \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[subnet-090cf41d5e0cdf437],securityGroups=[sg-0ca8167841704f04d],assignPublicIp=ENABLED}" \
    --service-registries "registryArn=arn:aws:servicediscovery:ap-south-1:4273-6630-1535:service/srv-6v3l3hs3nkxagvn2"