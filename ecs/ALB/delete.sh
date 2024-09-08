#!/bin/bash

# Variables
CLUSTER_NAME="roboshop"
SERVICE_NAME="web-service"
TARGET_GROUP_ARN=$(aws elbv2 describe-target-groups --names instana --query 'TargetGroups[0].TargetGroupArn' --output text)
LOAD_BALANCER_ARN=$(aws elbv2 describe-load-balancers --names roboshop --query 'LoadBalancers[0].LoadBalancerArn' --output text)
HOSTED_ZONE_ID="Z008243531Z79PQK793JX"
DOMAIN_NAME="ecs-instana.ullagallu.cloud"
CERTIFICATE_ARN=$(aws acm list-certificates --query "CertificateSummaryList[?DomainName=='$DOMAIN_NAME'].CertificateArn" --output text)

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

# 6. Get the current Route 53 DNS record
CURRENT_DNS_RECORD=$(aws route53 list-resource-record-sets \
    --hosted-zone-id $HOSTED_ZONE_ID \
    --query "ResourceRecordSets[?Name == '$DOMAIN_NAME.'] | [0]" \
    --output json)

# Extract current DNS value
DNS_VALUE=$(echo $CURRENT_DNS_RECORD | jq -r '.ResourceRecords[0].Value')

if [ "$DNS_VALUE" != "null" ]; then
    # 7. Delete Route 53 DNS record using current DNS value
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
              "Value": "'$DNS_VALUE'"
            }]
          }
        }]
      }'
    echo "Deleted Route 53 record for $DOMAIN_NAME"
else
    echo "No DNS record found for $DOMAIN_NAME"
fi

# 8. Delete ACM DNS validation record
ACM_DNS_RECORD=$(aws acm describe-certificate --certificate-arn $CERTIFICATE_ARN \
    --query 'Certificate.DomainValidationOptions[0].ResourceRecord' \
    --output json)

VALIDATION_NAME=$(echo $ACM_DNS_RECORD | jq -r '.Name')
VALIDATION_VALUE=$(echo $ACM_DNS_RECORD | jq -r '.Value')

if [ "$VALIDATION_NAME" != "null" ] && [ "$VALIDATION_VALUE" != "null" ]; then
    aws route53 change-resource-record-sets \
      --hosted-zone-id $HOSTED_ZONE_ID \
      --change-batch '{
        "Changes": [{
          "Action": "DELETE",
          "ResourceRecordSet": {
            "Name": "'$VALIDATION_NAME'",
            "Type": "CNAME",
            "TTL": 60,
            "ResourceRecords": [{
              "Value": "'$VALIDATION_VALUE'"
            }]
          }
        }]
      }'
    echo "Deleted ACM DNS validation record: $VALIDATION_NAME"
else
    echo "No ACM DNS validation record found."
fi

# 9. Delete ACM Certificate
if [ "$CERTIFICATE_ARN" != "None" ]; then
    aws acm delete-certificate --certificate-arn $CERTIFICATE_ARN
    echo "Deleted ACM Certificate: $CERTIFICATE_ARN"
fi
