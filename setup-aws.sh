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

newline
read -p "Enter username (profile name): " profile
read -p "Enter AKID: " akid
read -p "Enter SAK: " sak
read -p "Enter region [us-east-2]: " region
read -p "Enter default VPC: " vpc_id

newline
echo "Profile: ${profile}"
echo "AKID: ${akid}"
echo "SAK: ${sak}"
echo "Region: ${region}"
echo "VPC: ${vpc_id}"
newline
echo "Okay?"
newline
confirm
export AWS_PROFILE="${profile}"
export AWS_ACCESS_KEY_ID="${akid}"
export AWS_SECRET_ACCESS_KEY="${sak}"
export AWS_DEFAULT_REGION="${region}"
export AWS_VPC_ID="${vpc_id}"
echo "Exporting..."
echo "Wait 10 seconds"
newline
aws configure --profile ${profile}
newline
echo "Generating List..."
echo "Wait 10 more seconds"
newline
sleep 10
aws configure list
newline
sleep 3
aws configure list
confirm
newline
echo "Getting VPC..."
echo "Wait 10 final seconds"
newline
sleep 10
aws ec2 describe-vpcs --vpc-id ${vpc_id} --region us-east-2
newline
echo "Script Complete"
exit
aws configure --profile ${profile}
confirm
read -p "Enter your default VPC: " vpc_id
aws ec2 describe-vpcs --vpc-id ${vpc_id} --region us-east-2
read -p "Ready to proceed with AWS project"
exit
