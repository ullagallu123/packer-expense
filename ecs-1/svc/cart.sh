#!/bin/bash
aws ecs create-service \
  --cluster my-cluster \
  --service-name cart-service \
  --task-definition cart \
  --desired-count 1 \
  --launch-type EC2 \
  --network-configuration "awsvpcConfiguration={subnets=[subnet-xxxxxxxx],assignPublicIp=ENABLED}" \
  --service-registries "registries=[{registryArn=arn:aws:servicediscovery:region:account-id:service/service-id}]"
