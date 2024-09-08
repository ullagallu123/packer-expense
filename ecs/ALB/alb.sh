#!/bin/bash

# Create the Target Group
TARGET_GROUP_ARN=$(aws elbv2 create-target-group \
    --name instana \
    --protocol HTTP \
    --port 80 \
    --vpc-id vpc-0f82095ba1b38b677 \
    --target-type ip \
    --query 'TargetGroups[0].TargetGroupArn' \
    --output text)

echo "Target Group ARN: $TARGET_GROUP_ARN"

# Create the Load Balancer
LOAD_BALANCER_ARN=$(aws elbv2 create-load-balancer \
    --name roboshop \
    --subnets subnet-090cf41d5e0cdf437 subnet-02f12e14846b8477c \
    --security-groups sg-0ca8167841704f04d \
    --scheme internet-facing \
    --query 'LoadBalancers[0].LoadBalancerArn' \
    --output text)

echo "Load Balancer ARN: $LOAD_BALANCER_ARN"

# Create the Listener
aws elbv2 create-listener \
    --load-balancer-arn $LOAD_BALANCER_ARN \
    --protocol HTTP \
    --port 80 \
    --default-actions Type=forward,TargetGroupArn=$TARGET_GROUP_ARN

echo "Listener created for Load Balancer ARN: $LOAD_BALANCER_ARN"

# Update ECS Service with Load Balancer details
aws ecs update-service \
    --cluster roboshop \
    --service web-service \
    --load-balancers targetGroupArn=$TARGET_GROUP_ARN,containerName=web.instana,containerPort=80

echo "ECS Service updated with Target Group ARN: $TARGET_GROUP_ARN"

ALB_DNS=$(aws elbv2 describe-load-balancers \
    --names roboshop \
    --query 'LoadBalancers[0].DNSName' \
    --output text)

echo "ALB DNS Name: $ALB_DNS"


aws route53 change-resource-record-sets \
  --hosted-zone-id Z008243531Z79PQK793JX \
  --change-batch '{
    "Changes": [{
      "Action": "CREATE",
      "ResourceRecordSet": {
        "Name": "ecs-instana.ullagallu.cloud",
        "Type": "CNAME",
        "TTL": 1,
        "ResourceRecords": [{
          "Value": "'$ALB_DNS'"
        }]
      }
    }]
  }'

