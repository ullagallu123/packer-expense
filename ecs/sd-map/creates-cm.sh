#!/bin/bash
aws servicediscovery create-service \
    --name mongo \
    --namespace-id ns-5zsaptwcvbg3ve2z \
    --dns-config "NamespaceId=ns-5zsaptwcvbg3ve2z,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name mysql \
    --namespace-id ns-5zsaptwcvbg3ve2z \
    --dns-config "NamespaceId=ns-5zsaptwcvbg3ve2z,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name redis \
    --namespace-id ns-5zsaptwcvbg3ve2z \
    --dns-config "NamespaceId=ns-5zsaptwcvbg3ve2z,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name rabbit \
    --namespace-id ns-5zsaptwcvbg3ve2z \
    --dns-config "NamespaceId=ns-5zsaptwcvbg3ve2z,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name catalogue \
    --namespace-id ns-5zsaptwcvbg3ve2z \
    --dns-config "NamespaceId=ns-5zsaptwcvbg3ve2z,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name cart \
    --namespace-id ns-5zsaptwcvbg3ve2z \
    --dns-config "NamespaceId=ns-5zsaptwcvbg3ve2z,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name user \
    --namespace-id ns-5zsaptwcvbg3ve2z \
    --dns-config "NamespaceId=ns-5zsaptwcvbg3ve2z,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name shipping \
    --namespace-id ns-5zsaptwcvbg3ve2z \
    --dns-config "NamespaceId=ns-5zsaptwcvbg3ve2z,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name payment \
    --namespace-id ns-5zsaptwcvbg3ve2z \
    --dns-config "NamespaceId=ns-5zsaptwcvbg3ve2z,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name web \
    --namespace-id ns-5zsaptwcvbg3ve2z \
    --dns-config "NamespaceId=ns-5zsaptwcvbg3ve2z,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name debug \
    --namespace-id ns-5zsaptwcvbg3ve2z \
    --dns-config "NamespaceId=ns-5zsaptwcvbg3ve2z,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name dispatch \
    --namespace-id ns-5zsaptwcvbg3ve2z \
    --dns-config "NamespaceId=ns-5zsaptwcvbg3ve2z,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery list-services \
    --query "Services[*].[Id,Name]" \
    --output table

