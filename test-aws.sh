#!/bin/bash

function confirm() {
    read -p "Press <ENTER> to confirm you're ready to proceed... "
}
function newline() {
    echo ""
}

echo \
============================================================================= \
>> ./test-results.txt

echo Test Starting Execution At: $(date) >> ./test-results.txt

newline >> ./test-results.txt
echo "Testing Credentials (if you receive output, the test passed)" >> \
./test-results.txt
aws sts get-caller-identity >> ./test-results.txt

newline >> ./test-results.txt
echo "Configuration details of this profile are below" >> ./test-results.txt
aws configure list >> ./test-results.txt

newline >> ./test-results.txt
read -p "Enter your default VPC: " vpc_id
read -p "Enter region of the VPC: " vpc_region
newline >> ./test-results.txt
newline
newline
echo "---  Describing Default VPC  ---" >> ./test-results.txt
newline
aws ec2 describe-vpcs --vpc-id ${vpc_id} --region ${vpc_region} >> \
./test-results.txt

newline
echo "Tests complete, please review test results at ./test-results.txt"
newline >> ./test-results.txt
echo Test Finishing Execution At: $(date) >> ./test-results.txt

echo \
============================================================================= \
>> ./test-results.txt

exit