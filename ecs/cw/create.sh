#!/bin/bash
aws logs create-log-group --log-group-name /ecs/mongo
aws logs create-log-group --log-group-name /ecs/mysql
aws logs create-log-group --log-group-name /ecs/rabbit
aws logs create-log-group --log-group-name /ecs/redis
aws logs create-log-group --log-group-name /ecs/catalogue
aws logs create-log-group --log-group-name /ecs/cart
aws logs create-log-group --log-group-name /ecs/dispatch
aws logs create-log-group --log-group-name /ecs/payment
aws logs create-log-group --log-group-name /ecs/shipping
aws logs create-log-group --log-group-name /ecs/user
aws logs create-log-group --log-group-name /ecs/web
aws logs create-log-group --log-group-name /ecs/debug-utility

# for i in *.sh; do echo "Executing" $i; bash $i;done