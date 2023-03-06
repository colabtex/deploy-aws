#!/bin/bash

### Functions
function newline() {
    echo ""
}
function confirm() {
    read -p "Press <ENTER> to confirm you're ready to proceed... "
}
function end_program() {
    cat ${log_file}
    
    # Warn user
    echo "Press enter (twice) when ready to delete all resources"
    newline
    confirm
    confirm
    newline

    # Describe what to expect
    echo "Deleting the following (in this order):"
    echo "(routes) STUB"
    echo "(route table id)" ${rtb_id}
    echo "(internet gateway id)" ${igw_id}
    echo "(subnet id)" ${subnet_id}
    echo "(vpc id)" ${vpc_id}
    
    newline
    echo "Please stand by - will exit when complete..."
    
    newline
    aws ec2 delete-route-table --route-table-id ${rtb_id} | log_action
    aws ec2 detach-internet-gateway --internet-gateway-id ${igw_id} --vpc-id ${vpc_id} | log_action
    aws ec2 delete-internet-gateway --internet-gateway-id ${igw_id} | log_action
    aws ec2 delete-subnet --subnet-id ${subnet_id} | log_action
    aws ec2 delete-vpc --vpc-id ${vpc_id} | log_action

    newline
    echo "(Deletions successful if no output above)"
    echo "Deleted:"
    echo "(route table id) ${rtb_id}"
    echo "(internet gateway id) ${igw_id}"
    echo "(subnet id) ${subnet_id}"
    echo "(vpc id) ${vpc_id}"
    echo ""
    echo ""
    echo "      === LOG ===     "
    echo ""
    cat ${log_file}
    echo ""
    exit
}

newline
confirm
newline

### Run Initial Test
rm -f ./provisioning-test.txt
bash provisioning-test.sh

### log_action
log_file=./provision-log.txt
rm -f ${log_file}
touch ${log_file}
kvp_dir=./kvp_dir
log_action() {
    cat $1 >> ${log_file} 2>&1
}

newline
confirm
newline

### User/Local
echo "PWD: ${log_file}" | log_action
newline
read -p "Username: " username
### Setup
config_file=~/config.txt
rm -f ${config_file}
touch ${config_file}
echo "> Username: ${username}" >> ${config_file}
# keyname="${username}-key"
# echo "> Keyname: ${keyname}" >> ${config_file}
# cat ${config_file} | log_action
# aws ec2 delete-key-pair --key-name ${keyname} | log_action
kvp_dir=~/kvp_dir
rm -rf ${kvp_dir} | log_action
mkdir ${kvp_dir} | log_action
# rm -f devenv-key connect-to-instance.sh | log_action
# rm -rf ${kvp_dir} | log_action
# mkdir ${kvp_dir} | log_action
cd ${kvp_dir}
kvp_file=""
kvp_grep=""
kvp_key=""
kvp_value=""
process_command_output() {
  kvp_grep=`cat ${kvp_file} | egrep -i "${kvp_key}" | head -1` 2>&1 >> ${log_file}
  kvp_value=`echo ${kvp_grep} | sed 's/".*: "//g' | sed -e 's/",//g'` 2>&1 >> ${log_file}
}





newline
confirm
newline

###   VPC
echo "Creating VPC"
newline
create_vpc_0() {
    create_vpc_dir=${kvp_dir}/create_vpc
    mkdir -p ${create_vpc_dir}
    kvp_file=${create_vpc_dir}/create_vpc.json
    touch ${kvp_file}
    aws ec2 create-vpc --cidr-block 10.6.8.0/26 >> ${kvp_file}
}
create_vpc_0
kvp_key="VpcId"
process_command_output
vpc_id=${kvp_value}
echo "> Created VPC: ${vpc_id}" | log_action

newline
confirm
newline

###   Subnet
echo "Creating Subnet"
newline
create_subnet_0() {
  create_subnet_dir=${kvp_dir}/create_subnet
  mkdir -p ${create_subnet_dir}
  kvp_file=${create_subnet_dir}/create_subnet.json
  touch ${kvp_file}
  aws ec2 create-subnet --vpc-id ${vpc_id} --cidr-block 10.6.8.0/28 --availability-zone us-east-1a >> ${kvp_file}
}
create_subnet_0
kvp_key="SubnetId"
process_command_output
subnet_id=${kvp_value}
echo "> Created Subnet: ${subnet_id}" | log_action

newline
confirm
newline

###   Internet Gateway
echo "Creating IGW"
newline
create_igw_0() {
  create_igw_dir=${kvp_dir}/create_igw
  mkdir -p ${create_igw_dir}
  kvp_file=${create_igw_dir}/create_igw.json
  touch ${kvp_file}
  aws ec2 create-internet-gateway >> ${kvp_file}
}
create_igw_0
kvp_key="InternetGatewayId"
process_command_output
igw_id=${kvp_value}
echo "> Created Internet Gateway: ${igw_id}" | log_action

newline
confirm
newline

###   Attach IGW
echo "Attaching IGW"
newline
attach_igw_0() {
  attach_igw_dir=${kvp_dir}/attach_igw
  mkdir -p ${attach_igw_dir}
  kvp_file=${attach_igw_dir}/attach_igw.json
  touch ${kvp_file}
  aws ec2 attach-internet-gateway --vpc-id ${vpc_id} --internet-gateway-id ${igw_id} >> ${kvp_file}
}
attach_igw_0
process_command_output

newline
confirm
newline

###   Route Table
echo "Creating Route Table"
newline
create_rtb_0() {
  create_rtb_dir=${kvp_dir}/create_rtb
  mkdir -p ${create_rtb_dir}
  kvp_file=${create_rtb_dir}/create_rtb.json
  touch ${kvp_file}
  aws ec2 create-route-table --vpc-id ${vpc_id} >> ${kvp_file}
}
create_rtb_0
kvp_key="RouteTableId"
process_command_output
rtb_id=${kvp_value}
echo "> Created Route Table: ${rtb_id}" | log_action

newline
confirm
newline

###   Create Route
echo "Creating Route"
newline
create_rt_0() {
  create_rt_dir=${kvp_dir}/create_rt
  mkdir -p ${create_rt_dir}
  kvp_file=${create_rt_dir}/create_rt.json
  touch ${kvp_file}
  aws ec2 create-route --route-table-id ${rtb_id} --destination-cidr-block 0.0.0.0/0 --gateway-id ${igw_id} >> ${kvp_file}
}
create_rt_0
kvp_key="Routes"
process_command_output
rt_id=${kvp_value}
echo "> Created Route: ${rt_id}" | log_action



###   Describe Route Table
echo "Describing Route Table"
newline
describe_rtb_0() {
  describe_rtb_dir=${kvp_dir}/describe_rtb
  mkdir -p ${describe_rtb_dir}
  kvp_file=${describe_rtb_dir}/describe_rtb.json
  touch ${kvp_file}
  aws ec2 describe-route-tables --route-table-id ${rtb_id} >> ${kvp_file}
}
describe_rtb_0
kvp_key="Routes"
process_command_output
rt_id=${kvp_value}
echo "> Created Route: ${rt_id}" | log_action

newline
echo "Before trying to associate route table, we are going to first validate \
this script up until this point, including the tear down in end_program"
newline
confirm
newline

end_program
exit

###   Associate Route Table
echo "Associating Route Table"
newline
associate_rtb_0() {
  associate_rtb_dir=${kvp_dir}/associate_rtb
  mkdir -p ${associate_rtb_dir}
  kvp_file=${associate_rtb_dir}/associate_rtb.json
  touch ${kvp_file}
  aws ec2 associate-route-table --subnet-id ${subnet_id} --route-table-id ${rtb_id} >> ${kvp_file}
}
associate_rtb_0
kvp_key="AssociationId"
process_command_output
asc_id=${kvp_value}
echo "> Created Route Association: ${asc_id}" | log_action