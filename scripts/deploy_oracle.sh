#!/bin/bash

# Loop through AD indexes 0, 1, and 2
for i in {0..2}; do
    echo "Attempting deployment in Availability Domain index $i..."

    # Run terraform apply, passing the current index
    terraform apply -var="ad_index=$i" -auto-approve

    # Check the exit status of the terraform apply command
    if [ $? -eq 0 ]; then
        echo "Successfully deployed in AD index $i!"
        exit 0
    else
        echo "Deployment failed in AD index $i (likely out of capacity)."
        echo "Moving to the next Availability Domain..."
        sleep 5 # Brief pause before retrying
    fi
done

echo "All Availability Domains are currently out of capacity. Try again later."
exit 1
