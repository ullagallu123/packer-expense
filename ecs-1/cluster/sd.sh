aws servicediscovery create-service \
  --name instana \
  --dns-config "NamespaceId=ns-dqhk4l7ogtngs2wi,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=1}]" \
  --health-check-custom-config "FailureThreshold=5" 

aws servicediscovery list-services
