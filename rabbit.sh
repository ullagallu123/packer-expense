#!/bin/bash

# Set AWS region and other variables
REGION="ap-south-1"
BROKER_NAME="instana-rabbit"
HOSTED_ZONE_ID="Z0734300103KWSRCOUTDI"
RECORD_NAME="rb-rabbit.test.ullagallu.cloud"
TTL="1"

# Define RabbitMQ broker details
ENGINE_TYPE="RABBITMQ"
DEPLOYMENT_MODE="SINGLE_INSTANCE"
BROKER_INSTANCE_TYPE="mq.t3.micro"
USER_NAME="roboshop"
USER_PASSWORD="roboshop123"

# Function to create the broker
create_broker() {
    echo "Creating Amazon MQ broker '$BROKER_NAME'..."

    CREATE_OUTPUT=$(aws mq create-broker \
        --broker-name "$BROKER_NAME" \
        --engine-type "$ENGINE_TYPE" \
        --deployment-mode "$DEPLOYMENT_MODE" \
        --host-instance-type "$BROKER_INSTANCE_TYPE" \
        --users Username="$USER_NAME",Password="$USER_PASSWORD" \
        --publicly-accessible \
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
    echo "$BROKER_ID"
}

# Function to fetch broker endpoint
get_broker_endpoint() {
    echo "Fetching broker details..."
    BROKER_DETAILS=$(aws mq describe-broker \
        --broker-id "$1" \
        --region "$REGION" \
        --output json)

    BROKER_ENDPOINT=$(echo "$BROKER_DETAILS" | jq -r '.BrokerInstances[0].Endpoints[0]' | sed -e 's/amqps:\/\///' -e 's/:5671//')

    if [ -z "$BROKER_ENDPOINT" ]; then
        echo "Failed to fetch broker endpoint."
        exit 1
    fi

    echo "$BROKER_ENDPOINT"
}

# Check if broker exists
echo "Checking if Amazon MQ broker '$BROKER_NAME' already exists..."
EXISTING_BROKER=$(aws mq list-brokers --region "$REGION" --output json)

# Check if the broker exists in the list
BROKER_ID=$(echo "$EXISTING_BROKER" | jq -r --arg BROKER_NAME "$BROKER_NAME" \
    '.BrokerSummaries[] | select(.BrokerName == $BROKER_NAME) | .BrokerId')

if [ -n "$BROKER_ID" ]; then
    echo "Amazon MQ broker with name '$BROKER_NAME' already exists with ID: $BROKER_ID"
    BROKER_ENDPOINT=$(get_broker_endpoint "$BROKER_ID")
else
    BROKER_ID=$(create_broker)
    BROKER_ENDPOINT=$(get_broker_endpoint "$BROKER_ID")
fi

echo "Broker endpoint is: $BROKER_ENDPOINT"

# Create or update Route 53 DNS record
echo "Updating Route 53 DNS record..."
CHANGE_BATCH=$(jq -n \
    --arg RECORD_NAME "$RECORD_NAME" \
    --arg TTL "$TTL" \
    --arg BROKER_ENDPOINT "$BROKER_ENDPOINT" \
    '{
        "Changes": [
            {
                "Action": "UPSERT",
                "ResourceRecordSet": {
                    "Name": $RECORD_NAME,
                    "Type": "CNAME",
                    "TTL": ($TTL | tonumber),
                    "ResourceRecords": [
                        {
                            "Value": $BROKER_ENDPOINT
                        }
                    ]
                }
            }
        ]
    }')

aws route53 change-resource-record-sets \
    --hosted-zone-id "$HOSTED_ZONE_ID" \
    --change-batch "$CHANGE_BATCH" \
    --region "$REGION" \
    --output json

if [ $? -eq 0 ]; then
    echo "Route 53 DNS record updated."
else
    echo "Failed to update Route 53 DNS record."
    exit 1
fi
