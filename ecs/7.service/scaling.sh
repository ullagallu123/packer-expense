#!/bin/bash
aws ecs update-service \
    --cluster roboshop \
    --service web-service \
    --desired-count 1
