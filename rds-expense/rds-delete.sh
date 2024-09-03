#!/bin/bash
aws rds delete-db-instance \
    --db-instance-identifier instana \
    --skip-final-snapshot \
    --delete-automated-backups
