#!/bin/bash
aws rds create-db-instance \
    --db-instance-identifier expense \
    --db-instance-class db.t3.micro \
    --engine mysql \
    --allocated-storage 20 \
    --master-username root \
    --master-user-password ExpenseApp1

# 
