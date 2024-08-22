#!/bin/bash
aws ecs create-service \
    --cluster roboshop-cluster \
    --service-name mysql-service \
    --task-definition mysql \
    --desired-count 1 \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[subnet-0731498b80aa56290],securityGroups=[sg-00c0933258e06cea0],assignPublicIp=ENABLED}" \
    --service-registries "registries=[{registryArn=arn:aws:servicediscovery:ap-south-1:8069-6216-9196:service/srv-pqhbd5wmnk33g5za}]"
    