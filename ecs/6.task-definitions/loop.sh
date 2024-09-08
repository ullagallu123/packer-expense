#!/bin/bash

# Get the name of this script
CURRENT_SCRIPT=$(basename "$0")

# Loop through all scripts in the current directory
for script in *.sh; do
    # Check if the script is not the current script or one of the excluded scripts
    if [[ "$script" != "$CURRENT_SCRIPT" && "$script" != "debug.sh" && "$script" != "delete-td.sh" ]]; then
        echo "Executing $script..."
        bash "$script"
        if [[ $? -ne 0 ]]; then
            echo "Error occurred while executing $script"
        fi
    else
        echo "Skipping $script..."
    fi
done
