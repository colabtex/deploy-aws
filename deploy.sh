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
    read -p "Press <ENTER> to confirm... "
}

newline
echo Script started: $(date)

newline
echo "This script will serve to deploy the container as specified in the \
example requirements"

newline
# Prompt to confirm twice, because because proper dry-runs are for whimps
confirm
confirm

newline
echo "--- (the bulk of the scripts automation will go here) ---"

newline
echo "End of Script"

newline
echo Script Completed: $(date)
echo "Exiting..."

newline
exit