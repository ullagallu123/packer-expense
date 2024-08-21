#!/bin/bash            
REGION="ap-south-1"                  
CACHE_NAME="instana-redis"       
HOSTED_ZONE_ID="Z0734300103KWSRCOUTDI"        
RECORD_NAME="rb-redis.test.ullagallu.cloud" 
TTL="1"

create_redis_serverless() {
    echo "Creating Redis Serverless cache..."
    CACHE_ID=$(aws elasticache create-serverless-cache \
        --serverless-cache-name "$CACHE_NAME" \
        --engine redis \
        --region "$REGION" \
        --query 'ServerlessCache.CacheClusterId' \
        --output text)
    if [ $? -ne 0 ]; then
        echo "Failed to create Redis Serverless cache."
        exit 1
    fi
    echo "Created Redis Serverless cache with ID: $CACHE_ID"
}

# Function to get Redis endpoint
get_redis_endpoint() {
    echo "Fetching Redis endpoint..."
    ENDPOINT=$(aws elasticache describe-serverless-cache \
        --serverless-cache-name "$CACHE_NAME" \
        --region "$REGION" \
        --query 'ServerlessCache.Endpoint.Address' \
        --output text)
    if [ $? -ne 0 ]; then
        echo "Failed to fetch Redis endpoint."
        exit 1
    fi
    echo "Redis endpoint: $ENDPOINT"
}

# Function to update Route 53 DNS record
update_route53_record() {
    echo "Updating Route 53 DNS record..."
    cat > change-batch.json << EOF
{
  "Comment": "Update DNS record for Redis Serverless cache",
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "$RECORD_NAME",
        "Type": "CNAME",
        "TTL": $TTL,
        "ResourceRecords": [
          {
            "Value": "$ENDPOINT"
          }
        ]
      }
    }
  ]
}
EOF

    aws route53 change-resource-record-sets \
        --hosted-zone-id "$HOSTED_ZONE_ID" \
        --change-batch file://change-batch.json \
        --region "$REGION"

    if [ $? -ne 0 ]; then
        echo "Failed to update Route 53 DNS record."
        exit 1
    fi

    # Wait for the DNS change to propagate
    CHANGE_ID=$(aws route53 change-resource-record-sets \
        --hosted-zone-id "$HOSTED_ZONE_ID" \
        --change-batch file://change-batch.json \
        --region "$REGION" \
        --query 'ChangeInfo.Id' \
        --output text)

    aws route53 wait resource-record-set-changed \
        --hosted-zone-id "$HOSTED_ZONE_ID" \
        --change-id "$CHANGE_ID" \
        --region "$REGION"

    if [ $? -ne 0 ]; then
        echo "Failed to wait for DNS record change to propagate."
        exit 1
    fi
    echo "Route 53 DNS record updated successfully."
}

# Main script execution
create_redis_serverless
get_redis_endpoint
update_route53_record

echo "Script execution completed."
