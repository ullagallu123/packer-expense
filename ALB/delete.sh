#!/bin/bash

# Set Variables
VPC_ID="vpc-0ea2a79410b30a9bf"
SUBNET_ID_1="subnet-006fc8ce53a8f4008"
SUBNET_ID_2="subnet-03c6ec520043b57ac"

# Step 1: Delete Listeners
echo "Deleting listeners for the load balancer..."
LISTENER_ARNS=$(aws elbv2 describe-listeners --load-balancer-arn $ALB_ARN --query 'Listeners[*].ListenerArn' --output text)
for LISTENER_ARN in $LISTENER_ARNS; do
    aws elbv2 delete-listener --listener-arn $LISTENER_ARN
    echo "Deleted listener: $LISTENER_ARN"
done

# Step 2: Delete Load Balancer
echo "Deleting the load balancer..."
aws elbv2 delete-load-balancer --load-balancer-arn $ALB_ARN
echo "Waiting for load balancer deletion..."
aws elbv2 wait load-balancers-deleted --load-balancer-arns $ALB_ARN
echo "Deleted load balancer: $ALB_ARN"

# Step 3: Delete Target Groups
echo "Deleting target groups..."
aws elbv2 delete-target-group --target-group-arn $TG_EXPENSE_ARN
echo "Deleted target group: $TG_EXPENSE_ARN"
aws elbv2 delete-target-group --target-group-arn $TG_INSTANA_ARN
echo "Deleted target group: $TG_INSTANA_ARN"

# Step 4: Delete Security Group
echo "Revoking and deleting security group..."
aws ec2 revoke-security-group-ingress --group-id $SG_ID --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 revoke-security-group-ingress --group-id $SG_ID --protocol tcp --port 443 --cidr 0.0.0.0/0
aws ec2 delete-security-group --group-id $SG_ID
echo "Deleted security group: $SG_ID"

echo "All resources deleted successfully!"
