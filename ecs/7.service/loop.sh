#!/bin/bash

# 1. Deploy initial services
for script in mysql.sh mongo.sh redis.sh rabbit.sh; do
    echo "Executing $script..."
    bash "$script"
    if [[ $? -ne 0 ]]; then
        echo "Error occurred while executing $script"
        exit 1
    fi
done

# Wait for 1 minute
echo "Waiting for 1 minute before deploying next set of scripts..."
sleep 60

# 2. Deploy next set of services
for script in catalogue.sh user.sh cart.sh; do
    echo "Executing $script..."
    bash "$script"
    if [[ $? -ne 0 ]]; then
        echo "Error occurred while executing $script"
        exit 1
    fi
done

# Wait for 30 seconds
echo "Waiting for 30 seconds before deploying next set of scripts..."
sleep 30

# 3. Deploy next set of services
for script in shipping.sh payment.sh dispatch.sh; do
    echo "Executing $script..."
    bash "$script"
    if [[ $? -ne 0 ]]; then
        echo "Error occurred while executing $script"
        exit 1
    fi
done

# Wait for another 30 seconds
echo "Waiting for another 30 seconds before deploying the final script..."
sleep 30

# 4. Deploy final service
echo "Executing web.sh..."
bash "web.sh"
if [[ $? -ne 0 ]]; then
    echo "Error occurred while executing web.sh"
    exit 1
fi

echo "All scripts executed successfully."
