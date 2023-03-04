#!/bin/bash



### Logit
log_file=~/lgt.txt
rm -f ${log_file}
rm -f *.lgt
touch ${log_file}
touch ./logit.example.lgt
logit() {
  cat $1 >> ${log_file} 2>&1
}
echo "PWD: ${log_file}" | logit

### Setup
config_file=~/config.txt
rm -f ${config_file}
touch ${config_file}
username="wiehea1"
echo "> Username: ${username}" >> ${config_file}
keyname="${username}-key"
echo "> Keyname: ${keyname}" >> ${config_file}
cat ${config_file} | logit
aws ec2 delete-key-pair --key-name ${keyname} | logit
kvp_dir=~/kvp_dir
rm -r ${kvp_dir} | logit
mkdir ${kvp_dir} | logit
rm -f devenv-key connect-to-instance.sh | logit
rm -rf ${kvp_dir} | logit
mkdir ${kvp_dir} | logit
cd ${kvp_dir}
kvp_file=""
kvp_grep=""
kvp_key=""
kvp_value=""
process_command_output() {
  kvp_grep=`cat ${kvp_file} | egrep -i "${kvp_key}" | head -1` 2>&1 >> ${log_file}
  kvp_value=`echo ${kvp_grep} | sed 's/".*: "//g' | sed -e 's/",//g'` 2>&1 >> ${log_file}
}
end_program() {
  cat ${log_file}
  read -p "Press enter (twice) when ready to delete all resources"
  read -p "Press enter one more time to delete all resources"
  echo "Deleting the following (in this order):"
  echo "(route table id)" ${rtb_id}
  echo "(internet gateway id)" ${igw_id}
  echo "(subnet id)" ${subnet_id}
  echo "(vpc id)" ${vpc_id}
  echo "Please stand by - will exit when complete..."
  aws ec2 delete-route-table --route-table-id ${rtb_id} | logit
  aws ec2 detach-internet-gateway --internet-gateway-id ${igw_id} --vpc-id ${vpc_id} | logit
  aws ec2 delete-internet-gateway --internet-gateway-id ${igw_id} | logit
  aws ec2 delete-subnet --subnet-id ${subnet_id} | logit
  aws ec2 delete-vpc --vpc-id ${vpc_id} | logit
  echo "(Deletions successful if no output above)"
  echo "> Deleted:"
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



###   VPC
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
echo "> Created VPC: ${vpc_id}" | logit



###   Subnet
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
echo "> Created Subnet: ${subnet_id}" | logit



###   Internet Gateway
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
echo "> Created Internet Gateway: ${igw_id}" | logit



###   Attach IGW
attach_igw_0() {
  attach_igw_dir=${kvp_dir}/attach_igw
  mkdir -p ${attach_igw_dir}
  kvp_file=${attach_igw_dir}/attach_igw.json
  touch ${kvp_file}
  aws ec2 attach-internet-gateway --vpc-id ${vpc_id} --internet-gateway-id ${igw_id} >> ${kvp_file}
}
attach_igw_0
process_command_output



###   Route Table
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
echo "> Created Route Table: ${rtb_id}" | logit



###   Create Route
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
echo "> Created Route: ${rt_id}" | logit



###   Describe Route Table
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
echo "> Created Route: ${rt_id}" | logit



###   Associate Route Table
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
echo "> Created Route Association: ${asc_id}" | logit






end_program


