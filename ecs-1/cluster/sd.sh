aws servicediscovery create-service \
  --name my-service \
  --dns-config "NamespaceId=namespace-id,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=1}]" \
  --health-check-custom-config "FailureThreshold=1" \
  --query "Service.Id" --output text
