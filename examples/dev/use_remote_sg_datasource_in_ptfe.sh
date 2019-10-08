#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
export TERRAFORM_CONFIG="${DIR}/.terraformrc"

# This is for the time to wait when using demo_magic.sh
if [[ -z ${DEMO_WAIT} ]];then
  DEMO_WAIT=0
fi

# Demo magic gives wrappers for running commands in demo mode.   Also good for learning via CLI.
. ${DIR}/demo-magic.sh -d -p -w ${DEMO_WAIT}

source $HOME/awsSetEnv.sh

if [[ -z ${ATLAS_TOKEN} ]]; then
  echo "Missing Required Env Variable: ATLAS_TOKEN"
  echo "please set ATLAS_TOKEN so this script can create the necessary .terraformrc"
  echo "export ATLAS_TOKEN=<Terraform Enterprise App Token>"
  exit 1
fi

# look for my org and app tokens and switch for this shell env
if [[ ! -z ${APP_TFE_TOKEN} && ! -z ${ATLAS_TOKEN} ]]; then
  ATLAS_TOKEN=${APP_TFE_TOKEN} 
fi
echo
lblue "############################################"
lcyan "  Use Remote TFE Workspace Outputs Locally"
lblue "############################################"
echo
cyan "#"
cyan "### Review the terraform main.tf"
cyan "#"
p ""
echo
cat main.tf
p ""
echo
cyan "#"
cyan "### Create .terraformrc file with your TFE credentials"
cyan "#"
echo
p "# .terraformrc :

credentials \"app.terraform.io\" {
  token = "xxxxxxx"
}
"

# Create .terraformrc to enable TFE backend
cat <<- CONFIG > ${DIR}/.terraformrc
credentials "app.terraform.io" {
  token = "${ATLAS_TOKEN}"
}
CONFIG

cyan "#"
cyan "### Initialize your remote backend with 'terraform init'"
cyan "#"
echo
pe "terraform init"

echo
cyan "#"
cyan "### Run Terraform Plan"
cyan "#"
pe "terraform plan -var name_prefix=ppresto-dev-ec2"

echo
cyan "#"
cyan "### Run Terraform Apply"
cyan "#"
pe "terraform apply -var name_prefix=ppresto-dev-ec2 -auto-approve"

echo
cyan "#"
cyan "### Run Terraform Destroy"
cyan "#"
terraform destroy -var name_prefix=ppresto-dev-ec2 -auto-approve

# clean up sensitive files
rm -rf ${DIR}/.terraform* ${DIR}/*tfstate*