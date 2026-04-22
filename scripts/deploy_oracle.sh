#!/bin/bash

# Define the path to your Terraform directory
TF_DIR="$HOME/home-cloud-infra/terraform/oracle"
cd "$TF_DIR" || exit

echo "Starting continuous deployment loop for Oracle A1 Instance..."

while true; do
    for i in {0..2}; do
        echo "----------------------------------------------------"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Attempting AD index $i..."

        # Run terraform apply
        terraform apply -var="ad_index=$i" -auto-approve

        # Check exit status
        if [ $? -eq 0 ]; then
            echo "SUCCESS! Instance deployed in AD index $i."
            echo "Exiting loop."
            exit 0
        else
            echo "FAILED: AD index $i is out of capacity."
        fi
    done

    echo "----------------------------------------------------"
    echo "All Availability Domains exhausted."
    echo "Sleeping for 5 minutes to avoid API rate limits..."
    sleep 300
done
