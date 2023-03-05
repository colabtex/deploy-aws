#!/bin/bash

<<curl
    For now, install curl in this script.
    In another branch, will add command to install curl (prior to this script
    being called)
curl
function confirm() {
    read -p "Press <ENTER> to confirm you're ready to proceed... "
}
function newline() {
    echo ""
}
sudo apt install curl -y
# read -p "First, make sure your AWS IAM user is enabled - then press enter" dump
# read -p "(press enter) About to curl, unzip, and install AWS" dump
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o \
"awscliv2.zip"
unzip -u awscliv2.zip
sudo ./aws/install --update
echo "AWS Version -> "
aws --version
confirm

newline
echo "Go to the following URL:"
echo https://d-9067ada41c.awsapps.com/start
newline
confirm

read -p "Enter your default VPC: " vpc_id
read -p "Enter region of the VPC: " vpc_region
aws ec2 describe-vpcs --vpc-id ${vpc_id} --region ${vpc_region}
read -p "Ready to proceed with AWS project?"
exit
