#!/bin/bash
aws servicediscovery create-service \
    --name mongo \
    --namespace-id ns-4ek4go5zbr2xphlu \
    --dns-config "NamespaceId=ns-4ek4go5zbr2xphlu,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name redis \
    --namespace-id ns-4ek4go5zbr2xphlu \
    --dns-config "NamespaceId=ns-4ek4go5zbr2xphlu,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name rabbit \
    --namespace-id ns-4ek4go5zbr2xphlu \
    --dns-config "NamespaceId=ns-4ek4go5zbr2xphlu,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name catalogue \
    --namespace-id ns-4ek4go5zbr2xphlu \
    --dns-config "NamespaceId=ns-4ek4go5zbr2xphlu,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name cart \
    --namespace-id ns-4ek4go5zbr2xphlu \
    --dns-config "NamespaceId=ns-4ek4go5zbr2xphlu,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name user \
    --namespace-id ns-4ek4go5zbr2xphlu \
    --dns-config "NamespaceId=ns-4ek4go5zbr2xphlu,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name shipping \
    --namespace-id ns-4ek4go5zbr2xphlu \
    --dns-config "NamespaceId=ns-4ek4go5zbr2xphlu,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name payment \
    --namespace-id ns-4ek4go5zbr2xphlu \
    --dns-config "NamespaceId=ns-4ek4go5zbr2xphlu,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name web \
    --namespace-id ns-4ek4go5zbr2xphlu \
    --dns-config "NamespaceId=ns-4ek4go5zbr2xphlu,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name debug \
    --namespace-id ns-4ek4go5zbr2xphlu \
    --dns-config "NamespaceId=ns-4ek4go5zbr2xphlu,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery list-services \
    --query "Services[*].[Id,Name]" \
    --output table

