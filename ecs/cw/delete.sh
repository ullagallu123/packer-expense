#!/bin/bash
aws logs delete-log-group --log-group-name /ecs/mongo
aws logs delete-log-group --log-group-name /ecs/mysql
aws logs delete-log-group --log-group-name /ecs/rabbit
aws logs delete-log-group --log-group-name /ecs/redis
aws logs delete-log-group --log-group-name /ecs/catalogue
aws logs delete-log-group --log-group-name /ecs/cart
aws logs delete-log-group --log-group-name /ecs/dispatch
aws logs delete-log-group --log-group-name /ecs/payment
aws logs delete-log-group --log-group-name /ecs/shipping
aws logs delete-log-group --log-group-name /ecs/user
aws logs delete-log-group --log-group-name /ecs/web
