#!/bin/bash
aws iam create-role --role-name ecsTaskExecutionRole1 --assume-role-policy-document file://assume.json

aws iam attach-role-policy \
  --role-name ecsTaskExecutionRole1 \
  --policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy