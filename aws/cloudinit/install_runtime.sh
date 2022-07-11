#!/bin/bash

# FUNCTIONS #################################################
#############################################################


function sequence_install {

SEQ=`cut -d, -f1 sequence.txt | sort -u`

for x in $${SEQ}; do

for dir in `grep "^$${x}," sequence.txt| cut -d, -f2| xargs`; do

echo  "SEQ: $${x} :  $${dir}"

  echo $i
  cur_time=`date +'%m/%d %T.%3N'`
  echo "[$${cur_time}] Executing ansible install_runtime for dir [~temp/$${dir}]"

  if [ -z "${runtime_data}" ]
  then
    runtime="'pg':'$${ppg}'"
    ANSIBLE_CONFIG=~/ansible.cfg ansible-playbook $${dir}/install_runtime.yaml -e "{'ansible_python_interpreter': '/usr/bin/python', 'dir': $${dir}, 'user_email': $${account_email_ansible}, 'runtime_config': {'cloud': $${cloud_name}, 'site': $${region}, 'env': $${env_name}, 'id': $${host_num}, 'scale_set_id': ${asg_name}, 'resource_group_name': $${rg_name}, 'subscription_name': ${account_name}, $${runtime}}}" > $${dir}/stdout 2> $${dir}/stderr &
    vars="cloud=$cloud_name,site=$region,env=$env_name,id=$host_num,scale_set_id=${asg_name},resource_group_name=$rg_name,subscription_name=${account_name},runtime=$runtime,account_email=$account_email_ansible"

    echo "-----------" >> $${dir}/vars.txt
    echo "Directory $${dir}" >> $${dir}/vars.txt
    echo "-----------" >> $${dir}/vars.txt
    echo "sequence: $${x}"  >> $${dir}/vars.txt
    echo "start_time: `date +'%m/%d %T.%3N'` "  >> $${dir}/vars.txt
    cat $${dir}/package_details.txt >> $${dir}/vars.txt
    echo "" >> $${dir}/vars.txt
    echo "**command executed at runtime (modified for interactive execution)**" >> $${dir}/vars.txt
    echo "ANSIBLE_CONFIG=~/ansible.cfg ansible-playbook ~/temp/$${dir}/install_runtime.yaml -e \"{'ansible_python_interpreter': '/usr/bin/python', 'dir': $${dir}, 'runtime_config': {'cloud': $${cloud_name}, 'site': $${region}, 'env': $${env_name}, 'id': $${host_num}, 'scale_set_id': ${asg_name}, 'resource_group_name': $${rg_name}, 'subscription_name': ${account_name}, $${runtime}}}\"" >> $${dir}/vars.txt
    echo "" >> $${dir}/vars.txt
    echo "**variable substitution at runtime**" >> $${dir}/vars.txt
    awk -v RS=, '{print $0}' <<<"$vars" >> $${dir}/vars.txt

  else
    runtime="'pg':'$${ppg}', ${runtime_data}"
    ANSIBLE_CONFIG=~/ansible.cfg ansible-playbook $${dir}/install_runtime.yaml -e "{'ansible_python_interpreter': '/usr/bin/python', 'dir': $${dir}, 'user_email': $${account_email_ansible}, 'runtime_config': {'cloud': $${cloud_name}, 'site': $${region}, 'env': $${env_name}, 'id': $${host_num}, 'scale_set_id': ${asg_name}, 'resource_group_name': $${rg_name}, 'subscription_name': ${account_name}, $${runtime}}}" > $${dir}/stdout 2> $${dir}/stderr &
    vars="cloud=$cloud_name,site=$region,env=$env_name,id=$host_num,scale_set_id=${asg_name},resource_group_name=$rg_name,subscription_name=${account_name},runtime=$runtime,account_email=$account_email_ansible"

    echo "-----------" >> $${dir}/vars.txt
    echo "Directory $${dir}" >> $${dir}/vars.txt
    echo "-----------" >> $${dir}/vars.txt
    echo "sequence: $${x}"  >> $${dir}/vars.txt
    echo "start_time: `date +'%m/%d %T.%3N'` "  >> $${dir}/vars.txt
    cat $${dir}/package_details.txt >> $${dir}/vars.txt
    echo "" >> $${dir}/vars.txt
    echo "**command executed at runtime (modified for interactive execution)**" >> $${dir}/vars.txt
    echo "ANSIBLE_CONFIG=~/ansible.cfg ansible-playbook ~/temp/$${dir}/install_runtime.yaml -e \"{'ansible_python_interpreter': '/usr/bin/python', 'dir': $${dir}, 'runtime_config': {'cloud': $${cloud_name}, 'site': $${region}, 'env': $${env_name}, 'id': $${host_num}, 'scale_set_id': ${asg_name}, 'resource_group_name': $${rg_name}, 'subscription_name': ${account_name}, $${runtime}}}\"" >> $${dir}/vars.txt
    echo "" >> $${dir}/vars.txt
    echo "**variable substitution at runtime**" >> $${dir}/vars.txt
    awk -v RS=, '{print $0}' <<<"$vars" >> $${dir}/vars.txt

  fi
done
wait
done


}

#############################################################
#############################################################


instance_info=$(curl http://169.254.169.254/latest/dynamic/instance-identity/document)
instance_id=$(echo $instance_info | jq -r .instanceId)
region=$(echo $instance_info | jq -r .region)
availability_zone=$(echo $instance_info | jq -r .availabilityZone)
availability_id=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone-id)
account_email=`aws ssm get-parameters --names '/fdscloud/notification/email' | jq -r '.Parameters[].Value'`
export TOKEN=`aws secretsmanager get-secret-value --secret-id Devops/Github/Pipeline --query SecretString --output text --region $region`

json_data='
{
  "us-east-1a": {
    "site_code": "aaa",
    "host_num": "01"
  },
  "us-east-1b": {
    "site_code": "aab",
    "host_num": "02"
  },
  "us-east-1c": {
    "site_code": "aac",
    "host_num": "03"
  },
  "us-east-1d": {
    "site_code": "aad",
    "host_num": "04"
  },
  "us-east-1e": {
    "site_code": "aae",
    "host_num": "05"
  },
  "us-east-1f": {
    "site_code": "aaf",
    "host_num": "06"
  },
  "us-east-2a": {
    "site_code": "aaa",
    "host_num": "01"
  },
  "us-east-2b": {
    "site_code": "aab",
    "host_num": "02"
  },
  "us-east-2c": {
    "site_code": "aac",
    "host_num": "03"
  },
  "us-east-2d": {
    "site_code": "aad",
    "host_num": "04"
  },
  "us-east-2e": {
    "site_code": "aae",
    "host_num": "05"
  },
  "us-east-2f": {
    "site_code": "aaf",
    "host_num": "06"
  },
    "us-east-2f": {
    "site_code": "aaf",
    "host_num": "06"
  },
  "eu-west-2a": {
    "site_code": "aaa",
    "host_num": "01"
  },
  "eu-west-2b": {
    "site_code": "aab",
    "host_num": "02"
  },
  "eu-west-2c": {
    "site_code": "aac",
    "host_num": "03"
  },
  "eu-west-2d": {
    "site_code": "aad",
    "host_num": "04"
  },
  "eu-west-2e": {
    "site_code": "aae",
    "host_num": "05"
  },
  "eu-west-2f": {
    "site_code": "aaf",
    "host_num": "06"
  },
  "ap-southeast-1a": {
    "site_code": "aaa",
    "host_num": "01"
  },
  "ap-southeast-1b": {
    "site_code": "aab",
    "host_num": "02"
  },
  "ap-southeast-1c": {
    "site_code": "aac",
    "host_num": "03"
  },
  "ap-southeast-1d": {
    "site_code": "aad",
    "host_num": "04"
  },
  "ap-southeast-1e": {
    "site_code": "aae",
    "host_num": "05"
  },
  "ap-southeast-1f": {
    "site_code": "aaf",
    "host_num": "06"
  },
  "ap-southeast-2a": {
    "site_code": "aaa",
    "host_num": "01"
  },
  "ap-southeast-2b": {
    "site_code": "aab",
    "host_num": "02"
  },
  "ap-southeast-2c": {
    "site_code": "aac",
    "host_num": "03"
  },
  "ap-southeast-2d": {
    "site_code": "aad",
    "host_num": "04"
  },
  "ap-southeast-2e": {
    "site_code": "aae",
    "host_num": "05"
  },
  "ap-southeast-2f": {
    "site_code": "aaf",
    "host_num": "06"
  },
  "ap-northeast-1a": {
    "site_code": "aaa",
    "host_num": "01"
  },
  "ap-northeast-1b": {
    "site_code": "aab",
    "host_num": "02"
  },
  "ap-northeast-1c": {
    "site_code": "aac",
    "host_num": "03"
  },
  "ap-northeast-1d": {
    "site_code": "aad",
    "host_num": "04"
  },
  "ap-northeast-1e": {
    "site_code": "aae",
    "host_num": "05"
  },
  "ap-northeast-1f": {
    "site_code": "aaf",
    "host_num": "06"
  },
  "eu-central-1a": {
    "site_code": "aaa",
    "host_num": "01"
  },
  "eu-central-1b": {
    "site_code": "aab",
    "host_num": "02"
  },
  "eu-central-1c": {
    "site_code": "aac",
    "host_num": "03"
  },
  "eu-central-1d": {
    "site_code": "aad",
    "host_num": "04"
  },
  "eu-central-1e": {
    "site_code": "aae",
    "host_num": "05"
  },
  "eu-central-1f": {
    "site_code": "aaf",
    "host_num": "06"
  }
}'

json_ppg='
{
  "use1-az1": {
    "ppg": "pgb"
  },
  "use1-az2": {
    "ppg": "pgc"
  },
  "use1-az6": {
    "ppg": "pga"
  },
  "use2-az1": {
    "ppg": "pga"
  },
  "use2-az2": {
    "ppg": "pgb"
  },
  "use2-az3": {
    "ppg": "pgc"
  },
  "euw2-az2": {
    "ppg": "pga"
  },
  "euw2-az3": {
    "ppg": "pgb"
  },
  "euw2-az1": {
    "ppg": "pgc"
  },
  "apse1-az2": {
    "ppg": "pga"
  },
  "apse1-az1": {
    "ppg": "pgb"
  },
  "apse1-az3": {
    "ppg": "pgc"
  },
  "apse2-az1": {
    "ppg": "pga"
  },
  "apse2-az3": {
    "ppg": "pgb"
  },
  "apse2-az2": {
    "ppg": "pgc"
  },
  "apne1-az4": {
    "ppg": "pga"
  },
  "apne1-az1": {
    "ppg": "pgb"
  },
  "apne1-az2": {
    "ppg": "pgc"
  },
  "euc1-az2": {
    "ppg": "pga"
  },
  "euc1-az3": {
    "ppg": "pgb"
  },
  "euc1-az1": {
    "ppg": "pgc"
  }
}'

site_code=$(echo $json_data | jq -r .\"$availability_zone\".site_code)
host_num=$(echo $json_data | jq -r .\"$availability_zone\".host_num)
ppg=$(echo $json_ppg | jq -r .\"$availability_id\".ppg)
aws ec2 create-tags --resources $instance_id --tags Key=fds:SiteCode,Value=$site_code --region $region
aws ec2 create-tags --resources $instance_id --tags Key=fds:HostNum,Value=$host_num --region $region

cloud_name=`curl -s http://169.254.169.254/latest/meta-data/services/partition | cut -d- -f1`
env_name=`aws ec2 describe-instances --instance-id $(curl -s http://169.254.169.254/latest/meta-data/instance-id) --query "Reservations[*].Instances[*].Tags[?Key=='fds:InfraEnvironment'].Value" --region $region --output text`
rg_name=""

#set ansible config for overwriting during playbook exec
cat > ~/ansible.cfg << EOT
[defaults]
callback_whitelist = profile_tasks,community.general.mail
EOT

#install the following ansible-galaxy modules
ansible-galaxy collection install community.general

#misc install preperation
mkdir -p /var/lib/waagent/custom-script/download/
cur_time=`date +'%m/%d %T.%3N'`
echo "[$${cur_time}] Executing ansible to set hostname"

#addtional non-package ansible runtimes
cd ~
rm -rfv basic_setup
mkdir basic_setup
cd basic_setup
git init
git pull https://$TOKEN@github.factset.com/market-data-cloud/basic_setup.git
cd ..
ANSIBLE_CONFIG=~/ansible.cfg ansible-playbook ~/basic_setup/run.yaml --tags "fds_aws" -e "ansible_python_interpreter=/usr/bin/python" > /var/lib/waagent/custom-script/download/stdout 2> /var/lib/waagent/custom-script/download/stderr

cd ~/temp

#download ansible runtime failure playbook for execution during failed ansible tasks
curl -H "Accept: application/vnd.github.v3.raw" \
-H "Authorization: token $TOKEN" \
-O \
-L https://raw.github.factset.com/market-data-cloud/account_config/master/pipeline_files/ansible-runtime-failure.yaml

#set ansible email address for failure emails
##ansible email will be the username of the Jenkins build executor unless otherwise deploying to prod/ssvc, then maintain the account owner email.
if  [[ $${env_name} != "prod" ]] && [[ $${env_name} != "ssvc" ]]
then
  account_email=${username}@factset.com
fi
account_email_ansible=`echo '<'$${account_email}'>' $${account_email}`

# did the developer specify a install order ?
# ====================================================

egrep "^[1-9]" sequence.txt &>/dev/null

if [ $? -eq 0 ]; then

  sequence_install

else


#execute ansible runtime playbook for each baked package
for dir in `ls | egrep "^[1-9]" | sort -V`
do
  cur_time=`date +'%m/%d %T.%3N'`
  echo "[$${cur_time}] Executing ansible install_runtime for dir [~temp/$${dir}]"

  if [ -z "${runtime_data}" ]
  then
    runtime="'pg':'$${ppg}'"
    ANSIBLE_CONFIG=~/ansible.cfg ansible-playbook $${dir}/install_runtime.yaml -e "{'ansible_python_interpreter': '/usr/bin/python', 'dir': $${dir}, 'user_email': $${account_email_ansible}, 'runtime_config': {'cloud': $${cloud_name}, 'site': $${region}, 'env': $${env_name}, 'id': $${host_num}, 'scale_set_id': ${asg_name}, 'resource_group_name': $${rg_name}, 'subscription_name': ${account_name}, $${runtime}}}" > $${dir}/stdout 2> $${dir}/stderr &

    vars="cloud=$cloud_name,site=$region,env=$env_name,id=$host_num,scale_set_id=${asg_name},resource_group_name=$rg_name,subscription_name=${account_name},runtime=$runtime,account_email=$account_email_ansible"
    
    echo "-----------" >> $${dir}/vars.txt
    echo "Directory $${dir}" >> $${dir}/vars.txt
    echo "-----------" >> $${dir}/vars.txt
    cat $${dir}/package_details.txt >> $${dir}/vars.txt
    echo "" >> $${dir}/vars.txt
    echo "**command executed at runtime (modified for interactive execution)**" >> $${dir}/vars.txt
    echo "ANSIBLE_CONFIG=~/ansible.cfg ansible-playbook ~/temp/$${dir}/install_runtime.yaml -e \"{'ansible_python_interpreter': '/usr/bin/python', 'dir': $${dir}, 'runtime_config': {'cloud': $${cloud_name}, 'site': $${region}, 'env': $${env_name}, 'id': $${host_num}, 'scale_set_id': ${asg_name}, 'resource_group_name': $${rg_name}, 'subscription_name': ${account_name}, $${runtime}}}\"" >> $${dir}/vars.txt
    echo "" >> $${dir}/vars.txt
    echo "**variable substitution at runtime**" >> $${dir}/vars.txt
    awk -v RS=, '{print $0}' <<<"$vars" >> $${dir}/vars.txt

  else
    runtime="'pg':'$${ppg}', ${runtime_data}"
    ANSIBLE_CONFIG=~/ansible.cfg ansible-playbook $${dir}/install_runtime.yaml -e "{'ansible_python_interpreter': '/usr/bin/python', 'dir': $${dir}, 'user_email': $${account_email_ansible}, 'runtime_config': {'cloud': $${cloud_name}, 'site': $${region}, 'env': $${env_name}, 'id': $${host_num}, 'scale_set_id': ${asg_name}, 'resource_group_name': $${rg_name}, 'subscription_name': ${account_name}, $${runtime}}}" > $${dir}/stdout 2> $${dir}/stderr &

    vars="cloud=$cloud_name,site=$region,env=$env_name,id=$host_num,scale_set_id=${asg_name},resource_group_name=$rg_name,subscription_name=${account_name},runtime=$runtime,account_email=$account_email_ansible"
    
    echo "-----------" >> $${dir}/vars.txt
    echo "Directory $${dir}" >> $${dir}/vars.txt
    echo "-----------" >> $${dir}/vars.txt
    cat $${dir}/package_details.txt >> $${dir}/vars.txt
    echo "" >> $${dir}/vars.txt
    echo "**command executed at runtime (modified for interactive execution)**" >> $${dir}/vars.txt
    echo "ANSIBLE_CONFIG=~/ansible.cfg ansible-playbook ~/temp/$${dir}/install_runtime.yaml -e \"{'ansible_python_interpreter': '/usr/bin/python', 'dir': $${dir}, 'runtime_config': {'cloud': $${cloud_name}, 'site': $${region}, 'env': $${env_name}, 'id': $${host_num}, 'scale_set_id': ${asg_name}, 'resource_group_name': $${rg_name}, 'subscription_name': ${account_name}, $${runtime}}}\"" >> $${dir}/vars.txt
    echo "" >> $${dir}/vars.txt
    echo "**variable substitution at runtime**" >> $${dir}/vars.txt
    awk -v RS=, '{print $0}' <<<"$vars" >> $${dir}/vars.txt

  fi
done

fi

wait

# Var output consolidation
cur_time=`date +'%m/%d %T.%3N'`
echo "[$${cur_time}] Var output consolidation started"


egrep "^[1-9]" sequence.txt &>/dev/null

if [ $? -eq 0 ]; then
  SEQ_OUTPUTS=`sort sequence.txt  | cut -d, -f2 | xargs`

else

  SEQ_OUTPUTS=`ls | egrep "^[1-9]" | sort -V | xargs` 

fi

for dir in $${SEQ_OUTPUTS}
do
  cat $${dir}/vars.txt >> ~/temp/vars_consolidated.txt
done
cp ~/temp/vars_consolidated.txt /etc/fds/vars_consolidated.txt
cur_time=`date +'%m/%d %T.%3N'`
echo "[$${cur_time}] Var output consolidation ended"


# Log consolidation
cur_time=`date +'%m/%d %T.%3N'`
echo "[$${cur_time}] Log consolidation started"
for dir in $${SEQ_OUTPUTS}
do
  cat $${dir}/stdout >> /var/lib/waagent/custom-script/download/stdout
  cat $${dir}/stderr >> /var/lib/waagent/custom-script/download/stderr
done
cur_time=`date +'%m/%d %T.%3N'`
echo "[$${cur_time}] Log consolidation ended"

# Quick Fix for new users
cd ~
rm -rf basic_setup
mkdir basic_setup
cd basic_setup
git init
git pull https://$TOKEN@github.factset.com/market-data-cloud/basic_setup.git
cd ..
ANSIBLE_CONFIG=~/ansible.cfg ansible-playbook ~/basic_setup/run.yaml --tags "fds_people" -e "ansible_python_interpreter=/usr/bin/python" >> /var/lib/waagent/custom-script/download/stdout 2>> /var/lib/waagent/custom-script/download/stderr

# Convert user defined alerting thresholds by rounding up to the nearest 10
declare -A alertingArray
for i in ${alerting_thresholds}; do eval alertingArray`echo $${i} | sed 's/^/[/g' | sed 's/:/]=/g'`; done

##CPU
ALERT_THRESHOLD_CPU=`awk -v n=$${alertingArray[cpu]} 'BEGIN{print int((n+5)/10) * 10}'`
if [[ $ALERT_THRESHOLD_CPU -gt 90 ]]; then
  ALERT_THRESHOLD_CPU=90
elif (( $ALERT_THRESHOLD_CPU >= 1 && $ALERT_THRESHOLD_CPU < 30 )); then
  ALERT_THRESHOLD_CPU=30
elif [[ $ALERT_THRESHOLD_CPU -lt 1 ]]; then
  ALERT_THRESHOLD_CPU=""
fi

##MEM
ALERT_THRESHOLD_MEM=`awk -v n=$${alertingArray[mem]} 'BEGIN{print int((n+5)/10) * 10}'`
if [[ $ALERT_THRESHOLD_MEM -gt 90 ]]; then
  ALERT_THRESHOLD_MEM=90
elif (( $ALERT_THRESHOLD_MEM >= 1 && $ALERT_THRESHOLD_MEM < 30 )); then
  ALERT_THRESHOLD_MEM=30
elif [[ $ALERT_THRESHOLD_MEM -lt 1 ]]; then
  ALERT_THRESHOLD_MEM=""
fi

##NET
ALERT_THRESHOLD_NET=`awk -v n=$${alertingArray[net]} 'BEGIN{print int((n+5)/10) * 10}'`
if [[ $ALERT_THRESHOLD_NET -gt 90 ]]; then
  ALERT_THRESHOLD_NET=90
elif (( $ALERT_THRESHOLD_NET >= 1 && $ALERT_THRESHOLD_NET < 30 )); then
  ALERT_THRESHOLD_NET=30
elif [[ $ALERT_THRESHOLD_NET -lt 1 ]]; then
  ALERT_THRESHOLD_NET=""
fi

##DISK
ALERT_THRESHOLD_DISK=`awk -v n=$${alertingArray[disk]} 'BEGIN{print int((n+5)/10) * 10}'`
if [[ $ALERT_THRESHOLD_DISK -gt 90 ]]; then
  ALERT_THRESHOLD_DISK=90
elif (( $ALERT_THRESHOLD_DISK >= 1 && $ALERT_THRESHOLD_DISK < 30 )); then
  ALERT_THRESHOLD_DISK=30
elif [[ $ALERT_THRESHOLD_DISK -lt 1 ]]; then
  ALERT_THRESHOLD_DISK=""
fi

##output to ~/temp folder
echo "alert_threshold_cpu: "$ALERT_THRESHOLD_CPU >> ~/temp/alert_thresholds.txt
echo "alert_threshold_mem: "$ALERT_THRESHOLD_MEM >> ~/temp/alert_thresholds.txt
echo "alert_threshold_disk: "$ALERT_THRESHOLD_DISK >> ~/temp/alert_thresholds.txt

# Update telegraf config api key, tags, and format
echo "$(date) - Starting $0"

echo "$(date) - Stopping telegraf service"
systemctl stop telegraf.service

echo "$(date) - Updating telegraf conf file."

export TELEGRAF_CONFIG_FILE=/etc/telegraf/telegraf.conf
export REGION=$(curl http://169.254.169.254/latest/meta-data/placement/region)
export TELEGRAF_API_KEY=$(aws ssm get-parameters  --name "/fdscloud/ec2/telegraf_apikey" --region $REGION --with-decryption | jq -r '.Parameters[].Value' )
export ACCOUNT_ID=$(aws ssm get-parameters  --name "/fdscloud/account_id"  --region $REGION | jq -r '.Parameters[].Value' )
export ACCOUNT_NAME=$(aws ssm get-parameters  --name "/fdscloud/account_name"  --region $REGION | jq -r '.Parameters[].Value' )
export SBU=$(aws ssm get-parameters  --name "/fdscloud/sbu"  --region $REGION | jq -r '.Parameters[].Value' )
export INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
export INSTANCE_NAME=$(aws ec2 describe-tags --region $REGION --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values='Name'" | jq -r '.Tags[].Value')
export IMAGE_NAME=$(aws ec2 describe-tags --region $REGION --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values='fds:image_name'" | jq -r '.Tags[].Value')
export IMAGE_VERSION=$(aws ec2 describe-tags --region $REGION --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values='fds:image_version'" | jq -r '.Tags[].Value')
export ENVIRONMENT=$(aws ssm get-parameters  --name "/fdscloud/environment"  --region $REGION | jq -r '.Parameters[].Value' )
export STAGE=$(aws ssm get-parameters  --name "/fdscloud/environment"  --region $REGION | jq -r '.Parameters[].Value' )
export AUTOSCALING_GROUP=$(aws ec2 describe-tags --region $REGION --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values='aws:autoscaling:groupName'" | jq -r '.Tags[].Value')

sed -i 's/Authorization = \"DATAAPI apikey.*/Authorization = \"DATAAPI apikey=\\"'$TELEGRAF_API_KEY'\\"\"/g' $TELEGRAF_CONFIG_FILE
sed -i '/role = \"ROLE\"/d' $TELEGRAF_CONFIG_FILE
sed -i '/hostname = \"HOSTNAME\"/d' $TELEGRAF_CONFIG_FILE

ansible localhost  -m ini_file -a "path=$TELEGRAF_CONFIG_FILE section=global_tags option='  image_version' value='"\"$IMAGE_VERSION\""' mode='0640' owner='telegraf' group='telegraf' backup=yes"
ansible localhost  -m ini_file -a "path=$TELEGRAF_CONFIG_FILE section=global_tags option='  image_name' value='"\"$IMAGE_NAME\""' mode='0640' owner='telegraf' group='telegraf' backup=yes"
ansible localhost  -m ini_file -a "path=$TELEGRAF_CONFIG_FILE section=global_tags option='  account_name' value='"\"$ACCOUNT_NAME\""' mode='0640' owner='telegraf' group='telegraf' backup=yes"
ansible localhost  -m ini_file -a "path=$TELEGRAF_CONFIG_FILE section=global_tags option='  account_id' value='"\"$ACCOUNT_ID\""' mode='0640' owner='telegraf' group='telegraf' backup=yes"
ansible localhost  -m ini_file -a "path=$TELEGRAF_CONFIG_FILE section=global_tags option='  stage' value='"\"$STAGE\""' mode='0640' owner='telegraf' group='telegraf' backup=yes"
ansible localhost  -m ini_file -a "path=$TELEGRAF_CONFIG_FILE section=global_tags option='  instance_name' value='"\"$INSTANCE_NAME\""' mode='0640' owner='telegraf' group='telegraf' backup=yes"
ansible localhost  -m ini_file -a "path=$TELEGRAF_CONFIG_FILE section=global_tags option='  instance_id' value='"\"$INSTANCE_ID\""' mode='0640' owner='telegraf' group='telegraf' backup=yes"
ansible localhost  -m ini_file -a "path=$TELEGRAF_CONFIG_FILE section=global_tags option='  region' value='"\"$REGION\""' mode='0640' owner='telegraf' group='telegraf' backup=yes"
ansible localhost  -m ini_file -a "path=$TELEGRAF_CONFIG_FILE section=global_tags option='  sbu' value='"\"$SBU\""' mode='0640' owner='telegraf' group='telegraf' backup=yes"
ansible localhost  -m ini_file -a "path=$TELEGRAF_CONFIG_FILE section=global_tags option='  location' value='"\"aws\""' mode='0640' owner='telegraf' group='telegraf' backup=yes"
ansible localhost  -m ini_file -a "path=$TELEGRAF_CONFIG_FILE section=global_tags option='  profile' value='"\"standard\""' mode='0640' owner='telegraf' group='telegraf' backup=yes"
ansible localhost  -m ini_file -a "path=$TELEGRAF_CONFIG_FILE section=global_tags option='  autoscaling_group' value='"\"$AUTOSCALING_GROUP\""' mode='0640' owner='telegraf' group='telegraf' backup=yes"
ansible localhost  -m ini_file -a "path=$TELEGRAF_CONFIG_FILE section=global_tags option='  alert_threshold_cpu' value='"\"$ALERT_THRESHOLD_CPU\""' mode='0640' owner='telegraf' group='telegraf' backup=yes"
ansible localhost  -m ini_file -a "path=$TELEGRAF_CONFIG_FILE section=global_tags option='  alert_threshold_mem' value='"\"$ALERT_THRESHOLD_MEM\""' mode='0640' owner='telegraf' group='telegraf' backup=yes"
ansible localhost  -m ini_file -a "path=$TELEGRAF_CONFIG_FILE section=global_tags option='  alert_threshold_net' value='"\"$ALERT_THRESHOLD_NET\""' mode='0640' owner='telegraf' group='telegraf' backup=yes"
ansible localhost  -m ini_file -a "path=$TELEGRAF_CONFIG_FILE section=global_tags option='  alert_threshold_disk' value='"\"$ALERT_THRESHOLD_DISK\""' mode='0640' owner='telegraf' group='telegraf' backup=yes"

echo "$(date) - Starting telegraf service"
systemctl start telegraf.service

echo "$(date) - Enabling telegraf service"
systemctl enable telegraf.service

#unset the Github API token var
unset TOKEN