#!/bin/bash
aws servicediscovery create-private-dns-namespace \
    --name instana \
    --vpc vpc-07e30bcef51446692

echo "Here are the ns avaialable"
aws servicediscovery list-namespaces
