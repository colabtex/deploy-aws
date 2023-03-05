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
echo "Copy text from Option 2 and paste into the 'credentials' file, \
replacing 'key=${example_value}' 'key=actual_value'"
newline
echo "Make that same kind of replacement but this time with the 'config' file \
(using those same values you see in that same browser window)"
newline
echo "Copy those new files, credentials and config, and past them into ~/.aws/"
newline
confirm

newline
echo "Testing Credentials (if you receive output, the test passed)"
aws sts get-caller-identity

newline 
echo "Showing aws config list (just for reference)"
aws configure list

newline
echo "Will now try to view default vpc as a basic test"
echo "(first, need to supply the following details)"
newline
read -p "Enter your default VPC: " vpc_id
read -p "Enter region of the VPC: " vpc_region
newline
aws ec2 describe-vpcs --vpc-id ${vpc_id} --region ${vpc_region} >> ./dvpc.txt
echo "Showing output of describe-vpcs command"
cat ./dvpc.txt | less
echo "Finished showing output of describe-vpcs command, from dvpc.txt"
newline
read -p "Ready to proceed with AWS project?"
newline
confirm
exit
