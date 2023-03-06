#!/bin/bash

function confirm() {
    read -p "Press <ENTER> to confirm you're ready to proceed... "
}
function newline() {
    echo ""
}

echo \
============================================================================= \
>> ./provisioning-test.txt

echo Test Starting Execution At: $(date) >> ./provisioning-test.txt

newline >> ./provisioning-test.txt
echo "Testing Credentials (if you receive output, the test passed)" >> \
./provisioning-test.txt
aws sts get-caller-identity >> ./provisioning-test.txt

newline >> ./provisioning-test.txt
echo "Configuration details of this profile are below" >> ./provisioning-test.txt
aws configure list >> ./provisioning-test.txt

newline >> ./provisioning-test.txt
read -p "Enter your default VPC: " vpc_id
read -p "Enter region of the VPC: " vpc_region
newline >> ./provisioning-test.txt
newline
newline
echo "---  Describing Default VPC  ---" >> ./provisioning-test.txt
newline
aws ec2 describe-vpcs --vpc-id ${vpc_id} --region ${vpc_region} >> \
./provisioning-test.txt

newline
echo "Tests complete, please review test results at ./provisioning-test.txt"
newline >> ./provisioning-test.txt
echo Test Finishing Execution At: $(date) >> ./provisioning-test.txt

echo \
============================================================================= \
>> ./provisioning-test.txt

exit