#!/bin/bash

# Variables
VPC_ID="vpc-07e30bcef51446692"
NAMESPACE_NAME="roboshop.local"
SERVICE_NAME="roboshop"
TTL="1"

# Create Private DNS Namespace
NAMESPACE_ID=$(aws servicediscovery create-private-dns-namespace \
    --name "$NAMESPACE_NAME" \
    --vpc "$VPC_ID" \
    --query 'Namespace.Id' \
    --output text)

echo "Created namespace with ID: $NAMESPACE_ID"

# Create Service
SERVICE_ID=$(aws servicediscovery create-service \
    --name "$SERVICE_NAME" \
    --namespace-id "$NAMESPACE_ID" \
    --dns-config "NamespaceId=$NAMESPACE_ID,RoutingPolicy=MULTIVALUE,DnsRecords=[{Type=A,TTL=$TTL}]" \
    --query 'Service.Id' \
    --output text)

echo "Created service with ID: $SERVICE_ID"
