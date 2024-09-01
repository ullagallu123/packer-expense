#!/bin/bash


aws servicediscovery create-service \
    --name mysql \
    --namespace-id ns-dqhk4l7ogtngs2wi \
    --dns-config "NamespaceId=ns-dqhk4l7ogtngs2wi,RoutingPolicy=MULTIVALUE,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name mongo \
    --namespace-id ns-dqhk4l7ogtngs2wi \
    --dns-config "NamespaceId=ns-dqhk4l7ogtngs2wi,RoutingPolicy=MULTIVALUE,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name redis \
    --namespace-id ns-dqhk4l7ogtngs2wi \
    --dns-config "NamespaceId=ns-dqhk4l7ogtngs2wi,RoutingPolicy=MULTIVALUE,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name rabbit \
    --namespace-id ns-dqhk4l7ogtngs2wi \
    --dns-config "NamespaceId=ns-dqhk4l7ogtngs2wi,RoutingPolicy=MULTIVALUE,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name catalogue \
    --namespace-id ns-dqhk4l7ogtngs2wi \
    --dns-config "NamespaceId=ns-dqhk4l7ogtngs2wi,RoutingPolicy=MULTIVALUE,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name cart \
    --namespace-id ns-dqhk4l7ogtngs2wi \
    --dns-config "NamespaceId=ns-dqhk4l7ogtngs2wi,RoutingPolicy=MULTIVALUE,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name user \
    --namespace-id ns-dqhk4l7ogtngs2wi \
    --dns-config "NamespaceId=ns-dqhk4l7ogtngs2wi,RoutingPolicy=MULTIVALUE,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name shipping \
    --namespace-id ns-dqhk4l7ogtngs2wi \
    --dns-config "NamespaceId=ns-dqhk4l7ogtngs2wi,RoutingPolicy=MULTIVALUE,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name payment \
    --namespace-id ns-dqhk4l7ogtngs2wi \
    --dns-config "NamespaceId=ns-dqhk4l7ogtngs2wi,RoutingPolicy=MULTIVALUE,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name web \
    --namespace-id ns-dqhk4l7ogtngs2wi \
    --dns-config "NamespaceId=ns-dqhk4l7ogtngs2wi,RoutingPolicy=MULTIVALUE,DnsRecords=[{Type=A,TTL=60}]"
