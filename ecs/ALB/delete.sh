#!/bin/bash

# Variables
CLUSTER_NAME="roboshop"
SERVICE_NAME="web-service"
TARGET_GROUP_ARN=$(aws elbv2 describe-target-groups --names instana --query 'TargetGroups[0].TargetGroupArn' --output text)
LOAD_BALANCER_ARN=$(aws elbv2 describe-load-balancers --names roboshop --query 'LoadBalancers[0].LoadBalancerArn' --output text)
HOSTED_ZONE_ID="Z008243531Z79PQK793JX"
DOMAIN_NAME="ecs-instana.ullagallu.cloud"

# 1. Delete HTTPS Listener
HTTPS_LISTENER_ARN=$(aws elbv2 describe-listeners \
    --load-balancer-arn $LOAD_BALANCER_ARN \
    --query 'Listeners[?Protocol==`HTTPS`].ListenerArn' \
    --output text)

if [ "$HTTPS_LISTENER_ARN" != "None" ]; then
    aws elbv2 delete-listener --listener-arn $HTTPS_LISTENER_ARN
    echo "Deleted HTTPS Listener: $HTTPS_LISTENER_ARN"
fi

# 2. Delete HTTP Listener
HTTP_LISTENER_ARN=$(aws elbv2 describe-listeners \
    --load-balancer-arn $LOAD_BALANCER_ARN \
    --query 'Listeners[?Protocol==`HTTP`].ListenerArn' \
    --output text)

if [ "$HTTP_LISTENER_ARN" != "None" ]; then
    aws elbv2 delete-listener --listener-arn $HTTP_LISTENER_ARN
    echo "Deleted HTTP Listener: $HTTP_LISTENER_ARN"
fi

# 3. Delete Load Balancer
if [ "$LOAD_BALANCER_ARN" != "None" ]; then
    aws elbv2 delete-load-balancer --load-balancer-arn $LOAD_BALANCER_ARN
    echo "Deleted Load Balancer: $LOAD_BALANCER_ARN"
fi

# 4. Delete Target Group
if [ "$TARGET_GROUP_ARN" != "None" ]; then
    aws elbv2 delete-target-group --target-group-arn $TARGET_GROUP_ARN
    echo "Deleted Target Group: $TARGET_GROUP_ARN"
fi

# 5. Remove Load Balancer from ECS Service
aws ecs update-service \
    --cluster $CLUSTER_NAME \
    --service $SERVICE_NAME \
    --load-balancers "[]" \
    --desired-count 0

echo "Load Balancer removed from ECS service $SERVICE_NAME"

# 6. Delete Route 53 Record
aws route53 change-resource-record-sets \
  --hosted-zone-id $HOSTED_ZONE_ID \
  --change-batch '{
    "Changes": [{
      "Action": "DELETE",
      "ResourceRecordSet": {
        "Name": "'$DOMAIN_NAME'",
        "Type": "CNAME",
        "TTL": 1,
        "ResourceRecords": [{
          "Value": "'$LOAD_BALANCER_DNS'"
        }]
      }
    }]
  }'

echo "Deleted Route 53 record for $DOMAIN_NAME"
