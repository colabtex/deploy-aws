#!/bin/bash
read -p "(press enter) About to curl, unzip, and install AWS" dump
curel "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -u awscliv2.zip
sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
echo "AWS Version -> "
aws --version
google-chrome "https://d-9067ada41c.awsapps.com/start"
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
exit
