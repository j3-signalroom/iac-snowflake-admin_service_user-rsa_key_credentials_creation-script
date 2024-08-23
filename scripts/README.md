# Bash scripts
The below Bash script(s) are for local deployment and testing:

Name|What's it for
-|-
`run-terraform-locally.sh`|This script will log on to AWS via SSO, pass the AWS credentials to Terraform, and then execute the `Terraform`: `Init`, `Plan`, and `Apply` commands.