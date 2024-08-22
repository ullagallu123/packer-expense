


aws servicediscovery create-private-dns-namespace \
    --name roboshop.local \
    --vpc vpc-07e30bcef51446692 \
    --query 'Namespace.Id' \
    --output text

aws servicediscovery create-service \
    --name roboshop \
    --namespace-id ns-vejejj7lhxn6m66d \
    --dns-config "NamespaceId=ns-vejejj7lhxn6m66d,RoutingPolicy=MULTIVALUE,DnsRecords=[{Type=A,TTL=1}]" \
    --query 'Service.Id' \
    --output text

