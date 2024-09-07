#!/bin/bash
aws iam create-role --role-name ecsTaskExecutionRole1 --assume-role-policy-document file://assume.json

