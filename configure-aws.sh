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
echo "Copy text from Option 2 to match the format of credentials_example.txt, \
and put it in a file that's just named 'credentials'"
newline
echo "Make another file just named 'config' and copy the text from \
config_example.txt into it"
newline
echo "Copy those new files, credentials and config, and past them into ~/.aws/"
newline
confirm

echo "Testing Credentials (if you receive output, the test passed)"
aws sts get-caller-identity
newline 
echo "Showing aws config list (just for reference)"
aws config list
newline
echo "Will now try to view default vpc as a basic test"
newline
read -p "Enter your default VPC: " vpc_id
read -p "Enter region of the VPC: " vpc_region
newline
aws ec2 describe-vpcs --vpc-id ${vpc_id} --region ${vpc_region} >> ./dvpc.txt
echo "Showing output of describe-vpcs command"
cat ./dvpc.txt | less
echo "Finished showing output of describe-vpcs command, from dvpc.txt"
read -p "Ready to proceed with AWS project?"
newline
newline
read -p "Are you sure???"
newline
newline
confirm
echo "Calling Command: bash project.sh"
bash project.sh
newline
echo "Script Complete: configure-aws.sh"
exit
