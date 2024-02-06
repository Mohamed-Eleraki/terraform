#!/bin/bash

for region in $(aws ec2 describe-regions --output text --query 'Regions[*].RegionName'); do
    echo "Region: $region"
    aws ec2 describe-subnets --region $region
done



