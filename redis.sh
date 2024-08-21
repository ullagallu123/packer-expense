#!/bin/bash

# Set AWS region and other variables
REGION="ap-south-1"
CACHE_NAME="instana-redis1"
HOSTED_ZONE_ID="Z0734300103KWSRCOUTDI"
RECORD_NAME="rb-redis.test.ullagallu.cloud"
TTL="1"

# Create Redis Serverless cache
echo "Creating Redis Serverless cache..."
CREATE_OUTPUT=$(aws elasticache create-serverless-cache \
    --serverless-cache-name "$CACHE_NAME" \
    --engine redis \
    --region "$REGION")

# Extract Cache ID from create output
CACHE_ID=$(echo "$CREATE_OUTPUT" | grep -oP '(?<=ServerlessCacheId": ")[^"]*')

if [ -z "$CACHE_ID" ]; then
    echo "Failed to create Redis Serverless cache or retrieve Cache ID."
    exit 1
fi

echo "Created Redis Serverless cache with ID: $CACHE_ID"

# Fetch Redis endpoint
echo "Fetching Redis endpoint..."
ENDPOINT_OUTPUT=$(aws elasticache describe-serverless-caches \
    --region "$REGION")

# Extract endpoint address from output
ENDPOINT=$(echo "$ENDPOINT_OUTPUT" | jq -r \
    --arg CACHE_ID "$CACHE_ID" \
    '.ServerlessCaches[] | select(.ServerlessCacheId == $CACHE_ID) | .Endpoint.Address')

if [ -z "$ENDPOINT" ]; then
    echo "Failed to fetch Redis endpoint."
    exit 1
fi

echo "Redis endpoint is: $ENDPOINT"

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
                            "Value": "'"$ENDPOINT"'"
                        }
                    ]
                }
            }
        ]
    }' \
    --region "$REGION"

echo "Route 53 DNS record updated."
