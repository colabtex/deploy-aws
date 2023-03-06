#!/bin/bash

# SETUP
###############################################################################

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
  function separate() {
    newline
    confirm
    newline
  }

  separate
  ### Run Initial Test
  rm -f ./provisioning-test.txt
  bash provisioning-test.sh

  separate
  ### Log Action
  log_file=./provision-log.txt
  rm -f ${log_file}
  touch ${log_file}
  kvp_dir=./kvp_dir
  log_action() {
    cat $1 >> ${log_file} 2>&1
  }

  # User/Local
  echo "PWD: ${log_file}" | log_action
  newline
  read -p "Username: " username
  ### Setup
  config_file=./config.txt
  rm -f ${config_file}
  touch ${config_file}
  echo "> Username: ${username}" >> ${config_file}
  kvp_dir=./kvp_dir
  rm -rf ${kvp_dir} | log_action
  mkdir ${kvp_dir} | log_action
  cd ${kvp_dir}
  kvp_file=""
  kvp_grep=""
  kvp_key=""
  kvp_value=""
  process_command_output() {
    kvp_grep=`cat ${kvp_file} | egrep -i "${kvp_key}" | head -1` 2>&1 >> ${log_file}
    kvp_value=`echo ${kvp_grep} | sed 's/".*: "//g' | sed -e 's/",//g'` 2>&1 >> ${log_file}
  }


###############################################################################

separate

# SECURITY GROUPS
###############################################################################
  ### Security Group A
  echo "Creating Security A"
  create_sg_a() {
      create_sg_a_dir=${kvp_dir}/create_sg_a
      mkdir -p ${create_sg_a_dir}
      kvp_file=${create_sg_a_dir}/create_sg_a.json
      touch ${kvp_file}
      aws ec2 create-security-group --description "Security Group A" \
      --group-name sg_a >> ${kvp_file}
  }

  create_sg_a
  kvp_key="GroupId"
  process_command_output
  sg_a_id=${kvp_value}
  echo "> Created Security Group A: ${sg_a_id}" | log_action
  separate
  ### Security Group B
  echo "Creating Security B"
    newline
    create_sg_b() {
      create_sg_b_dir=${kvp_dir}/create_sg_b
      mkdir -p ${create_sg_b_dir}
      kvp_file=${create_sg_b_dir}/create_sg_b.json
      touch ${kvp_file}
      aws ec2 create-security-group --description "Security Group B"\
      --group-name sg_b >> ${kvp_file}
    }
    create_sg_b
    kvp_key="GroupId"
    process_command_output
    sg_b_id=${kvp_value}
  echo "> Created Security Group B: ${sg_b_id}" | log_action

###############################################################################

separate

# SSH KEYS
###############################################################################
  ### Create 2 SSH Keys
    # create ssh key 1
    keyname1="${keyname}1-key"
    rm -f ${keyname1}
    aws ec2 delete-key-pair --key-name ${keyname1} | log_action
    aws ec2 create-key-pair --key-name ${keyname1} --query 'KeyMaterial' \
    --output text > devenv1-key.pem
    chmod 400 devenv1-key.pem

    #############################################################################
    
    # create ssh key 2
    keyname2="${keyname}2-key"
    rm -f ${keyname2}
    aws ec2 delete-key-pair --key-name ${keyname2} | log_action
    aws ec2 create-key-pair --key-name ${keyname2} --query 'KeyMaterial' \
    --output text > devenv2-key.pem
    chmod 400 devenv2-key.pem
  ### Created 2 SSH Keys
###############################################################################

separate

# INSTANCES
###############################################################################
  ### Create 2 Instances
    # Create Instance A1
    echo "Creating Instance A1"
      create_instance_a1() {
        create_instance_a1_dir=${kvp_dir}/create_instance_a1
        mkdir -p ${create_instance_a1_dir}
        kvp_file=${create_instance_a1_dir}/create_instance_a1.json
        touch ${kvp_file}
        aws ec2 create-instance --image-id ami-09e67e426f25ce0d7 --count 1 \
        --instance-type t2.micro --key-name ${keyname1} --security-group-ids \
        >> ${kvp_file}
      }
      create_instance_a1
      kvp_key="InstanceId"
      process_command_output
      instance_a1_id=${kvp_value}
    echo "> Created Instance A1: ${instance_a1_id}" | log_action

    ###########################################################################

    # Create Instance B2
    echo "Creating Instance B2"
      create_instance_b2() {
        create_instance_b2_dir=${kvp_dir}/create_instance_b2
        mkdir -p ${create_instance_b2_dir}
        kvp_file=${create_instance_b2_dir}/create_instance_b2.json
        touch ${kvp_file}
        aws ec2 create-instance --image-id ami-09e67e426f25ce0d7 --count 1 \
        --instance-type t2.micro --key-name ${keyname1} --security-group-ids \
        >> ${kvp_file}
      }
      create_instance_b2
      kvp_key="InstanceId"
      process_command_output
      instance_b2_id=${kvp_value}
    echo "> Created Instance B2: ${instance_b2_id}" | log_action
  ### Created 2 Instances
###############################################################################

end_program
exit


###   Subnet B
echo "Creating Subnet B"
newline
create_subnet_b() {
  create_subnet_b_dir=${kvp_dir}/create_subnet_b
  mkdir -p ${create_subnet_b_dir}
  kvp_file=${create_subnet_b_dir}/create_subnet_b.json
  touch ${kvp_file}
  aws ec2 create-subnet --vpc-id ${vpc_id} --cidr-block 10.0.1.0/24 \
  --availability-zone us-east-1a >> ${kvp_file}
}
create_subnet_b
kvp_key="SubnetId"
process_command_output
subnet_b_id=${kvp_value}
echo "> Created Subnet: ${subnet_b_id}" | log_action

separate

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

separate

###   Attach IGW
echo "Attaching IGW"
newline
attach_igw_0() {
  attach_igw_dir=${kvp_dir}/attach_igw
  mkdir -p ${attach_igw_dir}
  kvp_file=${attach_igw_dir}/attach_igw.json
  touch ${kvp_file}
  aws ec2 attach-internet-gateway --vpc-id ${vpc_id} --internet-gateway-id \
  ${igw_id} >> ${kvp_file}
}
attach_igw_0
process_command_output

separate

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

separate

###   Create Route
echo "Creating Route"
newline
create_rt_0() {
  create_rt_dir=${kvp_dir}/create_rt
  mkdir -p ${create_rt_dir}
  kvp_file=${create_rt_dir}/create_rt.json
  touch ${kvp_file}
  aws ec2 create-route --route-table-id ${rtb_id} --destination-cidr-block \
  0.0.0.0/0 --gateway-id ${igw_id} >> ${kvp_file}
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
separate

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
  aws ec2 associate-route-table --subnet-id ${subnet_id} --route-table-id \
  ${rtb_id} >> ${kvp_file}
}
associate_rtb_0
kvp_key="AssociationId"
process_command_output
asc_id=${kvp_value}
echo "> Created Route Association: ${asc_id}" | log_action