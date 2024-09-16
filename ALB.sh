#!/bin/bash

# Set Variables
VPC_ID="vpc-0ea2a79410b30a9bf"
SUBNET_ID_1="subnet-006fc8ce53a8f4008"
SUBNET_ID_2="subnet-03c6ec520043b57ac"

# Step 1: Create Security Group
echo "Creating Security Group..."
SG_ID=$(aws ec2 create-security-group --group-name ALB-SG --description "Allow HTTP and HTTPS" --vpc-id $VPC_ID --query 'GroupId' --output text)
echo "Created Security Group with ID: $SG_ID"

# Step 2: Authorize Ingress Rules for Security Group
echo "Authorizing ingress for ports 80 and 443..."
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 443 --cidr 0.0.0.0/0

# Step 3: Create Target Groups
echo "Creating target groups..."
TG_EXPENSE_ARN=$(aws elbv2 create-target-group \
    --name expense-ullagallu \
    --protocol HTTP \
    --port 80 \
    --vpc-id $VPC_ID \
    --health-check-protocol HTTP \
    --health-check-port 80 \
    --health-check-path "/" \
    --query 'TargetGroups[0].TargetGroupArn' --output text)
echo "Created target group expense-ullagallu with ARN: $TG_EXPENSE_ARN"

TG_INSTANA_ARN=$(aws elbv2 create-target-group \
    --name instana-ullagallu \
    --protocol HTTP \
    --port 80 \
    --vpc-id $VPC_ID \
    --health-check-protocol HTTP \
    --health-check-port 80 \
    --health-check-path "/" \
    --query 'TargetGroups[0].TargetGroupArn' --output text)
echo "Created target group instana-ullagallu with ARN: $TG_INSTANA_ARN"

# Step 4: Create Load Balancer
echo "Creating Load Balancer..."
ALB_ARN=$(aws elbv2 create-load-balancer \
    --name ullagallu \
    --subnets $SUBNET_ID_1 $SUBNET_ID_2 \
    --security-groups $SG_ID \
    --scheme internet-facing \
    --type application \
    --query 'LoadBalancers[0].LoadBalancerArn' --output text)
echo "Created Load Balancer with ARN: $ALB_ARN"

# Step 5: Create Listener with fixed response
echo "Creating Listener with default fixed response..."
aws elbv2 create-listener \
    --load-balancer-arn $ALB_ARN \
    --protocol HTTP \
    --port 80 \
    --default-actions Type=fixed-response,FixedResponseConfig="{MessageBody='</h1>Welcome kops</h1>',StatusCode='200',ContentType='text/html'}"

echo "Script completed successfully!"
