#!/bin/bash

TFvar=$1
TGvar=$2

wgetTestTF=`wget --server-response --spider "https://releases.hashicorp.com/terraform/${TFvar}/terraform_${TFvar}_linux_amd64.zip" 2>&1 | grep -c '200 OK'`
wgetTestTG=`wget --server-response --spider "https://github.com/gruntwork-io/terragrunt/releases/download/v${TGvar}/terragrunt_linux_amd64" 2>&1 | grep -c '200 OK'`

echo "------------------------------------"
echo "Downloading the following binaries.."
echo "------------------------------------"
echo "Terraform"
if [[ $? == 0 && $wgetTestTF == 1 ]]; then wget -q "https://releases.hashicorp.com/terraform/${TFvar}/terraform_${TFvar}_linux_amd64.zip" -O terraform && unzip -o -q terraform; else echo 'Failed, exiting' && exit 1; fi
echo "Done"
echo "Terragrunt"
if [[ $? == 0 && $wgetTestTG == 1 ]]; then wget -q wget -q "https://github.com/gruntwork-io/terragrunt/releases/download/v${TGvar}/terragrunt_linux_amd64" -O terragrunt; else echo 'Failed, exiting' && exit 1; fi
chmod +x terragrunt
echo "Done"

echo "-----------------------------------"
echo "Validating the following binaries.."
echo "-----------------------------------"
echo "Terraform"
./terraform -v | head -n 1
if [[ $? != 0 ]]; then echo "Failed, exiting" && exit 1; fi
echo "Done"
echo "Terragrunt"
./terragrunt -v | head -n 1
if [[ $? != 0 ]]; then echo "Failed, exiting" && exit 1; fi
echo "Done"

echo "Success"

exit 0
