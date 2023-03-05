#!/bin/bash

echo ""
echo "Starting..."

<<Strategy
    Create a VPC called "jumpbox" ( you will wait to use it until you 
    actually need it though, since your other work done up until this point may
    have rendered this step unnecessary). This will serve to test your IAM 
    user's ability to work with your aws ec2 instance.

    (then finish the rest of the owl...)
Strategy

function newline() {
    echo ""
}
function confirm() {
    read -p "Press <ENTER> to confrim you're ready to proceed... "
}

newline
echo Script started: $(date)

newline
echo "This script will serve to deploy the container as specified in the \
example requirements"
newline
echo "First, make sure the following prerequsites are met: "
newline
echo 1. Your IAM Identity Center user account is enabled
newline
echo 2. You are able to log into [ https://d-9067ada41c.awsapps.com/start ]
newline
echo 3. It is recommended to copy over your credentials and config files now
newline
confirm
newline
# Prompt to confirm twice, because because proper dry-runs are for whimps
echo "Are you ready to run this script? Dry runs are not being utilized"
newline
confirm

newline
echo "Now calling configure-aws.sh..."
bash configure-aws.sh
echo "Returned from configure-aws.sh"

newline
echo "Now calling project.sh..."
bash project.sh
echo "Returned from project.sh"

newline
echo "End of Script"

newline
echo Script Completed: $(date)
echo "Exiting..."

newline
exit