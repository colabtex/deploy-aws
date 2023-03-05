#!/bin/bash
<<curl
    For now, install curl in this script.
    In another branch, will add command to install curl (prior to this script
    being called)
curl
function confirm() {
    read -p "Press <ENTER> to confrim you're ready to proceed... "
}
sudo apt install curl -y
# read -p "First, make sure your AWS IAM user is enabled - then press enter" dump
# read -p "(press enter) About to curl, unzip, and install AWS" dump
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o \
"awscliv2.zip"
unzip -u awscliv2.zip
sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli \
--update
echo "AWS Version -> "
aws --version
confirm
firefox "https://d-9067ada41c.awsapps.com/start" &
echo "Copy and paste AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY_ID, and \
AWS_SESSION_TOKEN below (all in one text block selection), then press enter:"
confirm
echo ""
read AWS_ACCESS_KEY_ID_command
read AWS_SECRET_ACCESS_KEY_ID_command
read AWS_SESSION_TOKEN_command
${AWS_ACCESS_KEY_ID_command}
${AWS_SECRET_ACCESS_KEY_ID_command}
${AWS_SESSION_TOKEN_command}
rm -f awscliv2.zip
ls ./
read -p "Enter a valid VPC ID: " vpc_id
aws ec2 describe-vpc --vpc-ids ${vpc_id}
read -p "Ready to proceed with AWS project 
exit
