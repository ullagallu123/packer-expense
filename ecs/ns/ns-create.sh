#!/bin/bash
aws servicediscovery create-private-dns-namespace \
    --name instana \
    --vpc vpc-0f82095ba1b38b677

echo "Here are the ns avaialable"
aws servicediscovery list-namespaces
