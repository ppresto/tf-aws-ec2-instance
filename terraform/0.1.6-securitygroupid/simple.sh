#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
export TERRAFORM_CONFIG="${DIR}/.terraformrc"

# This is for the time to wait when using demo_magic.sh
if [[ -z ${DEMO_WAIT} ]];then
  DEMO_WAIT=0
fi

# Demo magic gives wrappers for running commands in demo mode.   Also good for learning via CLI.
. ${DIR}/../../demo-magic.sh -d -p -w ${DEMO_WAIT}

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

cyan "Create .terraformrc file with your TFE credentials"
p "cat <<- CONFIG > ./.terraformrc
credentials \"app.terraform.io\" {
  token = "xxxxxxx"
}
CONFIG"

# Create .terraformrc to enable TFE backend
cat <<- CONFIG > ${DIR}/.terraformrc
credentials "app.terraform.io" {
  token = "${ATLAS_TOKEN}"
}
CONFIG

cyan "Initialize your remote backend with 'terraform init'"
pe "terraform init"

cyan "Run Terraform apply"
pe "terraform apply -auto-approve"

cyan "Run Terraform destroy"
pe "terraform destroy -auto-approve"

# clean up sensitive files
rm -rf ${DIR}/.terraform*
rm ${DIR}/*.tfstate*