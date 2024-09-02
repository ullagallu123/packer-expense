#!/bin/bash
aws ecs create-service \
    --cluster roboshop \
    --service-name dispatch-service \
    --task-definition dispatch \
    --desired-count 1 \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[subnet-0731498b80aa56290],securityGroups=[sg-00c0933258e06cea0],assignPublicIp=ENABLED}" \
    --service-registries "registryArn=arn:aws:servicediscovery:ap-south-1:8069-6216-9196:service/srv-l3y2q2sek2lz7ck5"