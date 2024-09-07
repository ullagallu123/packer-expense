#!/bin/bash

# Variables
DB_INSTANCE_IDENTIFIER="instana"
DB_INSTANCE_CLASS="db.t3.micro"
ENGINE="mysql"
ALLOCATED_STORAGE=20
MASTER_USERNAME="root"
MASTER_USER_PASSWORD="RoboShop1"
ZONE_NAME="ullagallu.cloud"
DOMAIN_NAME="rb-mysql.${ZONE_NAME}"
DB_INSTANCE_ENDPOINT=""

# Get the hosted zone ID for the specified zone name
HOSTED_ZONE_ID=$(aws route53 list-hosted-zones-by-name --dns-name $ZONE_NAME --query "HostedZones[0].Id" --output text)

# Check if RDS instance already exists
DB_INSTANCE_EXISTS=$(aws rds describe-db-instances --db-instance-identifier $DB_INSTANCE_IDENTIFIER --query "DBInstances[0].DBInstanceIdentifier" --output text 2>/dev/null)

if [ "$DB_INSTANCE_EXISTS" == "$DB_INSTANCE_IDENTIFIER" ]; then
    echo "RDS instance already exists. Skipping creation."
else
    # Create RDS instance
    aws rds create-db-instance \
        --db-instance-identifier $DB_INSTANCE_IDENTIFIER \
        --db-instance-class $DB_INSTANCE_CLASS \
        --engine $ENGINE \
        --allocated-storage $ALLOCATED_STORAGE \
        --master-username $MASTER_USERNAME \
        --master-user-password $MASTER_USER_PASSWORD

    # Wait for the DB instance to be available
    echo "Waiting for RDS instance to become available..."
    aws rds wait db-instance-available --db-instance-identifier $DB_INSTANCE_IDENTIFIER
fi

# Get the endpoint of the RDS instance
DB_INSTANCE_ENDPOINT=$(aws rds describe-db-instances \
    --db-instance-identifier $DB_INSTANCE_IDENTIFIER \
    --query "DBInstances[0].Endpoint.Address" \
    --output text)

# Check if Route 53 record already exists
RECORD_EXISTS=$(aws route53 list-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --query "ResourceRecordSets[?Name == '$DOMAIN_NAME.']" --output text)

if [ -n "$RECORD_EXISTS" ]; then
    echo "Route 53 record already exists. Skipping creation."
else
    # Create a Route 53 record
    aws route53 change-resource-record-sets \
        --hosted-zone-id $HOSTED_ZONE_ID \
        --change-batch '{
          "Changes": [{
            "Action": "CREATE",
            "ResourceRecordSet": {
              "Name": "'"$DOMAIN_NAME"'",
              "Type": "CNAME",
              "TTL": 300,
              "ResourceRecords": [{"Value": "'"$DB_INSTANCE_ENDPOINT"'"}]
            }
          }]
        }'
fi

echo "RDS instance and Route 53 record setup complete."
