#!/bin/bash

# Variables
VPC_ID="vpc-0f82095ba1b38b677"
SUBNETS=("subnet-090cf41d5e0cdf437" "subnet-02f12e14846b8477c")
SECURITY_GROUP="sg-0ca8167841704f04d"
CLUSTER_NAME="roboshop"
SERVICE_NAME="web-service"
HOSTED_ZONE_ID="Z008243531Z79PQK793JX"
DOMAIN_NAME="ecs-instana.ullagallu.cloud"

# 1. Create the Target Group
TARGET_GROUP_ARN=$(aws elbv2 create-target-group \
    --name instana \
    --protocol HTTP \
    --port 80 \
    --vpc-id $VPC_ID \
    --target-type ip \
    --query 'TargetGroups[0].TargetGroupArn' \
    --output text)

echo "Target Group ARN: $TARGET_GROUP_ARN"

# 2. Create the Load Balancer
LOAD_BALANCER_ARN=$(aws elbv2 create-load-balancer \
    --name roboshop \
    --subnets ${SUBNETS[@]} \
    --security-groups $SECURITY_GROUP \
    --scheme internet-facing \
    --query 'LoadBalancers[0].LoadBalancerArn' \
    --output text)

echo "Load Balancer ARN: $LOAD_BALANCER_ARN"

# 3. Create the HTTP Listener
aws elbv2 create-listener \
    --load-balancer-arn $LOAD_BALANCER_ARN \
    --protocol HTTP \
    --port 80 \
    --default-actions Type=forward,TargetGroupArn=$TARGET_GROUP_ARN

echo "HTTP Listener created for Load Balancer ARN: $LOAD_BALANCER_ARN"

# 4. Update ECS Service with Load Balancer details
aws ecs update-service \
    --cluster $CLUSTER_NAME \
    --service $SERVICE_NAME \
    --load-balancers targetGroupArn=$TARGET_GROUP_ARN,containerName=web,containerPort=80

echo "ECS Service updated with Target Group ARN: $TARGET_GROUP_ARN"

# 5. Get ALB DNS Name
ALB_DNS=$(aws elbv2 describe-load-balancers \
    --names roboshop \
    --query 'LoadBalancers[0].DNSName' \
    --output text)

echo "ALB DNS Name: $ALB_DNS"

# 6. Create Route 53 DNS record for ALB
aws route53 change-resource-record-sets \
  --hosted-zone-id $HOSTED_ZONE_ID \
  --change-batch '{
    "Changes": [{
      "Action": "CREATE",
      "ResourceRecordSet": {
        "Name": "'$DOMAIN_NAME'",
        "Type": "CNAME",
        "TTL": 1,
        "ResourceRecords": [{
          "Value": "'$ALB_DNS'"
        }]
      }
    }]
  }'

echo "Route 53 CNAME record created for $DOMAIN_NAME"

# 7. Request ACM certificate and get CERTIFICATE_ARN dynamically
CERTIFICATE_ARN=$(aws acm request-certificate \
    --domain-name $DOMAIN_NAME \
    --validation-method DNS \
    --options CertificateTransparencyLoggingPreference=ENABLED \
    --query 'CertificateArn' \
    --output text)

echo "ACM Certificate requested: $CERTIFICATE_ARN"

# 8. Get DNS validation record
VALIDATION_RECORD=$(aws acm describe-certificate \
    --certificate-arn $CERTIFICATE_ARN \
    --query 'Certificate.DomainValidationOptions[0].ResourceRecord' \
    --output json)

VALIDATION_NAME=$(echo $VALIDATION_RECORD | jq -r '.Name')
VALIDATION_VALUE=$(echo $VALIDATION_RECORD | jq -r '.Value')

# Check if the values are null
if [ -z "$VALIDATION_NAME" ] || [ -z "$VALIDATION_VALUE" ]; then
    echo "Failed to retrieve DNS validation record. Exiting."
    exit 1
fi

# 9. Add DNS validation record to Route 53
aws route53 change-resource-record-sets \
    --hosted-zone-id $HOSTED_ZONE_ID \
    --change-batch '{
      "Changes": [{
        "Action": "UPSERT",
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

echo "DNS validation record added for $DOMAIN_NAME"

# 10. Create HTTPS Listener with dynamic CERTIFICATE_ARN
aws elbv2 create-listener \
    --load-balancer-arn $LOAD_BALANCER_ARN \
    --protocol HTTPS \
    --port 443 \
    --default-actions Type=forward,TargetGroupArn=$TARGET_GROUP_ARN \
    --certificates CertificateArn=$CERTIFICATE_ARN \
    --ssl-policy ELBSecurityPolicy-2016-08

echo "HTTPS Listener created for Load Balancer ARN: $LOAD_BALANCER_ARN"
