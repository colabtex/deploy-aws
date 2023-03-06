#!/bin/bash

### Security Group A
echo "Creating Seucirty A"
    newline
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
    newline
    confirm
    newline
### Security Group B
echo "Creating Seucirty B"
    newline
    create_sg_b() {
        create_sg_b_dir=${kvp_dir}/create_sg_b
        mkdir -p ${create_sg_b_dir}
        kvp_file=${create_sg_b_dir}/create_sg_b.json
        touch ${kvp_file}
        aws ec2 create-security-group --description "Security Group B" \
        --group-name sg_b >> ${kvp_file}
    }
    create_sg_b
    kvp_key="GroupId"
    process_command_output
    sg_b_id=${kvp_value}
echo "> Created Security Group B: ${sg_b_id}" | log_bction

