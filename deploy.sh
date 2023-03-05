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
echo 1. Your IAM Identity Center user is enabled
confirm
newline
echo 2. AWS has been installed - and if not, run bash setup-aws.sh
confirm
newline
echo 3. You are able to log into [ https://d-9067ada41c.awsapps.com/start ]

confirm
newline
echo 4. If you have already entered keys, its okay to do so again momentarily
confirm
newline


newline
# Prompt to confirm twice, because because proper dry-runs are for whimps
echo "Are you ready to run this script? Dry runs are not being utilized"
confirm
confirm

newline
echo "--- (the bulk of the scripts automation will go here) ---"
# <<tproduser11923
#     Example production username from aws documentation is preppended with t to 
#     that its a test profile and appended with obfuscated acronym for uniqueness
# tproduser11923
# aws configure --profile tproduser11923
# confirm

newline
echo "End of Script"

newline
echo Script Completed: $(date)
echo "Exiting..."

newline
exit