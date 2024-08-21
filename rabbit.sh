#!/bin/bash

REGION="ap-south-1"
BROKER_NAME="instana-rabbit"
HOSTED_ZONE_ID="Z0734300103KWSRCOUTDI"
RECORD_NAME="rb-rabbit.test.ullagallu.cloud"
TTL="1"


ENGINE_TYPE="RABBITMQ"
DEPLOYMENT_MODE="SINGLE_INSTANCE"
BROKER_INSTANCE_TYPE="mq.t3.micro"
USER_NAME="rabbit"
USER_PASSWORD="rabbitmq1"


echo "Checking if Amazon MQ broker '$BROKER_NAME' already exists..."

EXISTING_BROKER=$(aws mq describe-broker \
    --broker-id "$BROKER_NAME" \
    --region "$REGION" \
    --output json 2>/dev/null)

if [ $? -eq 0 ]; then
    echo "Amazon MQ broker with name '$BROKER_NAME' already exists."
    BROKER_ID=$(echo "$EXISTING_BROKER" | jq -r '.BrokerId')
    BROKER_ENDPOINT=$(echo "$EXISTING_BROKER" | jq -r '.Endpoints[0]')
else
    echo "Creating Amazon MQ broker '$BROKER_NAME'..."

    CREATE_OUTPUT=$(aws mq create-broker \
        --broker-name "$BROKER_NAME" \
        --broker-engine-type "$ENGINE_TYPE" \
        --deployment-mode "$DEPLOYMENT_MODE" \
        --instance-type "$BROKER_INSTANCE_TYPE" \
        --users Username="$USER_NAME",Password="$USER_PASSWORD" \
        --region "$REGION" \
        --output json)

    if [ $? -ne 0 ]; then
        echo "Failed to create Amazon MQ broker."
        exit 1
    fi

    # Extract broker ID from create output
    BROKER_ID=$(echo "$CREATE_OUTPUT" | jq -r '.BrokerId')

    if [ -z "$BROKER_ID" ]; then
        echo "Failed to retrieve Broker ID."
        exit 1
    fi

    echo "Created Amazon MQ broker with ID: $BROKER_ID"

    # Fetch broker details to get the endpoint
    echo "Fetching broker details..."
    BROKER_DETAILS=$(aws mq describe-broker \
        --broker-id "$BROKER_ID" \
        --region "$REGION" \
        --output json)

    BROKER_ENDPOINT=$(echo "$BROKER_DETAILS" | jq -r '.Endpoints[0]')
    
    if [ -z "$BROKER_ENDPOINT" ]; then
        echo "Failed to fetch broker endpoint."
        exit 1
    fi
fi

echo "Broker endpoint is: $BROKER_ENDPOINT"

# Create or update Route 53 DNS record
echo "Updating Route 53 DNS record..."
aws route53 change-resource-record-sets \
    --hosted-zone-id "$HOSTED_ZONE_ID" \
    --change-batch '{
        "Changes": [
            {
                "Action": "UPSERT",
                "ResourceRecordSet": {
                    "Name": "'"$RECORD_NAME"'",
                    "Type": "CNAME",
                    "TTL": '"$TTL"',
                    "ResourceRecords": [
                        {
                            "Value": "'"$BROKER_ENDPOINT"'"
                        }
                    ]
                }
            }
        ]
    }' \
    --region "$REGION" \
    --output json

if [ $? -eq 0 ]; then
    echo "Route 53 DNS record updated."
else
    echo "Failed to update Route 53 DNS record."
    exit 1
fi
