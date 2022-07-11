remote_state {
  backend = "s3"
  config = {
    bucket          = "fdss3-${get_aws_account_id()}-misc-data-${get_env("TF_VAR_aws_region")}"
    key             = "quotes_terraform_${get_env("TF_VAR_aws_region")}.tfstate"
    region          = get_env("TF_VAR_aws_region")
    encrypt         = true
    dynamodb_table  = "${get_aws_account_id()}-tfstate-locks"
  }
}
