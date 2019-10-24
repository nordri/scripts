#!/usr/bin/env bash
set -e

# Run ./ami-per-region.sh
#
# Will generate a yaml-style output with the latest AWS AMI id per region.
# 
# Mappings:
#   RegionMap:
#     eu-north-1:
#       AMI: ami-4bd45f35
#     ap-south-1:
#       AMI: ami-03dcedc81ea3e7e27
#     eu-west-3:
#       AMI: ami-080d4d4c37b0aa206
#     eu-west-2:
#       AMI: ami-0cbe2951c7cd54704
#     eu-west-1:
#       AMI: ami-03746875d916becc0
#     ap-northeast-2:
#       AMI: ami-0a25005e83c56767a
# .....
#
# for CloudFormation templates.
#
# Fede Diaz (nordri@gmail.com) May 2018

regions=$(aws ec2 describe-regions --output text --query 'Regions[*].RegionName')

echo "Mappings:"
echo "  RegionMap:"

for region in $regions
do
  echo "    $region:"
  echo "      AMI: $(aws ec2 describe-images --owners 099720109477 --region $region --filters 'Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-????????' 'Name=state,Values=available' --output json | jq -r '.Images | sort_by(.CreationDate) | last(.[]).ImageId')"
done
