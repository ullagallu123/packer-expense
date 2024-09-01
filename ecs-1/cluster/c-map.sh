#!/bin/bash
aws servicediscovery create-private-dns-namespace \
  --name instana \
  --vpc vpc-07e30bcef51446692


aws servicediscovery list-namespaces
