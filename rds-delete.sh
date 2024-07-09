#!/bin/bash
aws rds delete-db-instance \
    --db-instance-identifier expense \
    --skip-final-snapshot \
    --delete-automated-backups
