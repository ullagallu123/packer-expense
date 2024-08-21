#!/bin/bash            
AWS_REGION="ap-south-1"                  
REDIS_CLUSTER_ID="my-redis-cluster"      
REDIS_NODE_TYPE="cache.t3.micro"          
REDIS_ENGINE_VERSION="7.x"                
REDIS_PORT="6379"                         
REDIS_NAME="rb-redis.test.ullagallu.cloud" 

ROUTE_53_HOSTED_ZONE_ID="Z0734300103KWSRCOUTDI" 
# Check if the Redis cluster already exists
echo "Checking if Redis cluster '$REDIS_CLUSTER_ID' exists..."
CLUSTER_STATUS=$(aws elasticache describe-cache-clusters --cache-cluster-id "$REDIS_CLUSTER_ID" --query "CacheClusters[0].CacheClusterStatus" --output text --profile "$AWS_PROFILE" --region "$AWS_REGION" 2>/dev/null)

if [ "$CLUSTER_STATUS" == "available" ]; then
    echo "Redis cluster '$REDIS_CLUSTER_ID' already exists and is available."
else
    echo "Creating Redis cluster '$REDIS_CLUSTER_ID'..."
    aws elasticache create-cache-cluster \
        --cache-cluster-id "$REDIS_CLUSTER_ID" \
        --cache-node-type "$REDIS_NODE_TYPE" \
        --engine redis \
        --engine-version "$REDIS_ENGINE_VERSION" \
        --num-cache-nodes 1 \
        --port "$REDIS_PORT" \
        --region "$AWS_REGION"
    
    echo "Waiting for Redis cluster to be available..."
    aws elasticache wait cache-cluster-available \
        --cache-cluster-id "$REDIS_CLUSTER_ID" \
        --region "$AWS_REGION"
    
    echo "Redis cluster '$REDIS_CLUSTER_ID' created and available."
fi

# Get the Redis endpoint
REDIS_ENDPOINT=$(aws elasticache describe-cache-clusters --cache-cluster-id "$REDIS_CLUSTER_ID" --query "CacheClusters[0].Endpoint.Address" --output text --profile "$AWS_PROFILE" --region "$AWS_REGION")

# Update Route 53 DNS record
echo "Updating Route 53 DNS record for '$REDIS_NAME'..."
aws route53 change-resource-record-sets \
    --hosted-zone-id "$ROUTE_53_HOSTED_ZONE_ID" \
    --change-batch '{
        "Changes": [
            {
                "Action": "UPSERT",
                "ResourceRecordSet": {
                    "Name": "'"$REDIS_NAME"'",
                    "Type": "CNAME",
                    "TTL": 60,
                    "ResourceRecords": [
                        {
                            "Value": "'"$REDIS_ENDPOINT"'"
                        }
                    ]
                }
            }
        ]
    }' \
    --region "$AWS_REGION"

echo "DNS record for '$REDIS_NAME' updated to point to '$REDIS_ENDPOINT'."

echo "Script completed."
