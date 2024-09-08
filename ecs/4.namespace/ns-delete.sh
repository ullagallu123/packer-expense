#!/bin/bash

# Check if namespace name is provided as an argument
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <namespace-name>"
  exit 1
fi

# Namespace name to delete
namespace_name=$1

# Get the namespace ID for the provided namespace name
ns=$(aws servicediscovery list-namespaces --query "Namespaces[?Name=='$namespace_name'].Id" --output text)

# Check if namespace ID was found
if [ -z "$ns" ]; then
  echo "Namespace '$namespace_name' not found."
  exit 1
fi

# Delete the namespace
aws servicediscovery delete-namespace --id "$ns"

echo "Namespace '$namespace_name' with ID $ns has been deleted."
