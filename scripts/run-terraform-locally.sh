#!/bin/bash

#
# *** Script Syntax ***
# scripts/run-terraform-locally.sh --environment=<ENVIRONMENT_NAME> --profile=<SSO_PROFILE_NAME> --action=<create | destroy> --snowflake_account=<SNOWFLAKE_ACCOUNT> --snowflake_user=<SNOWFLAKE_USER> --snowflake_password=<SNOWFLAKE_PASSWORD> --snowflake_warehouse=<SNOWFLAKE_WAREHOUSE>
#
#

# Check if arguments were supplied; otherwise exit script
if [ ! -n "$1" ]
then
    echo
    echo "(Error Message 001)  You did not include all four arguments in the call."
    echo
    echo "Usage:  Require all four arguments ---> `basename $0` --environment=<ENVIRONMENT_NAME> --profile=<SSO_PROFILE_NAME> --action=<create | destroy> --snowflake_account=<SNOWFLAKE_ACCOUNT> --snowflake_user=<SNOWFLAKE_USER> --snowflake_password=<SNOWFLAKE_PASSWORD> --snowflake_warehouse=<SNOWFLAKE_WAREHOUSE>"
    echo
    exit 85 # Common GNU/Linux Exit Code for 'Interrupted system call should be restarted'
fi

# Get the arguments passed
arg_count=0
action_argument_supplied=false
for arg in "$@" # $@ sees arguments as separate words
do
    case $arg in
        *"--profile="*)
            AWS_PROFILE=$arg;;
        *"--environment="*)
            arg_length=14
            environment_name=${arg:$arg_length:$(expr ${#arg} - $arg_length)};;
        *"--action=create"*)
            action_argument_supplied=true
            create_action=true;;
        *"--action=destroy"*)
            action_argument_supplied=true
            create_action=false;;
        *"--snowflake_account="*)
            arg_length=20
            snowflake_account=${arg:$arg_length:$(expr ${#arg} - $arg_length)};;
        *"--snowflake_user="*)
            arg_length=17
            snowflake_user=${arg:$arg_length:$(expr ${#arg} - $arg_length)};;
        *"--snowflake_password="*)
            arg_length=21
            snowflake_password=${arg:$arg_length:$(expr ${#arg} - $arg_length)};;
        *"--snowflake_warehouse="*)
            arg_length=22
            snowflake_warehouse=${arg:$arg_length:$(expr ${#arg} - $arg_length)};;
    esac
    let "arg_count+=1"
done

# Check required --environment argument was supplied
if [ -z $environment_name ]
then
    echo
    echo "(Error Message 002)  You did not include the proper use of the --environment=<ENVIRONMENT_NAME> argument in the call."
    echo
    echo "Usage:  Require all four arguments ---> `basename $0` --environment=<ENVIRONMENT_NAME> --profile=<SSO_PROFILE_NAME> --action=<create | destroy> --snowflake_account=<SNOWFLAKE_ACCOUNT> --snowflake_user=<SNOWFLAKE_USER> --snowflake_password=<SNOWFLAKE_PASSWORD> --snowflake_warehouse=<SNOWFLAKE_WAREHOUSE>"
    echo
    exit 85 # Common GNU/Linux Exit Code for 'Interrupted system call should be restarted'
fi

# Check required --profile argument was supplied
if [ -z $AWS_PROFILE ]
then
    echo
    echo "(Error Message 003)  You did not include the proper use of the --profile=<AWS_SSO_SSO_PROFILE_NAME> argument in the call."
    echo
    echo "Usage:  Require all four arguments ---> `basename $0` --environment=<ENVIRONMENT_NAME> --profile=<SSO_PROFILE_NAME> --action=<create | destroy> --snowflake_account=<SNOWFLAKE_ACCOUNT> --snowflake_user=<SNOWFLAKE_USER> --snowflake_password=<SNOWFLAKE_PASSWORD> --snowflake_warehouse=<SNOWFLAKE_WAREHOUSE>"
    echo
    exit 85 # Common GNU/Linux Exit Code for 'Interrupted system call should be restarted'
fi

# Check required --action argument was supplied
if [ "$action_argument_supplied" = false ]
then
    echo
    echo "(Error Message 004)  You did not include the proper use of the --action=<create | destroy> argument in the call."
    echo
    echo "Usage:  Require all four arguments ---> `basename $0` --environment=<ENVIRONMENT_NAME> --profile=<SSO_PROFILE_NAME> --action=<create | destroy> --snowflake_account=<SNOWFLAKE_ACCOUNT> --snowflake_user=<SNOWFLAKE_USER> --snowflake_password=<SNOWFLAKE_PASSWORD> --snowflake_warehouse=<SNOWFLAKE_WAREHOUSE>"
    echo
    exit 85 # Common GNU/Linux Exit Code for 'Interrupted system call should be restarted'
fi

# Check required --snowflake_account argument was supplied
if [ -z $snowflake_account ]
then
    echo
    echo "(Error Message 005)  You did not include the proper use of the --snowflake_account=<SNOWFLAKE_ACCOUNT> argument in the call."
    echo
    echo "Usage:  Require all four arguments ---> `basename $0` --environment=<ENVIRONMENT_NAME> --profile=<SSO_PROFILE_NAME> --action=<create | destroy> --snowflake_account=<SNOWFLAKE_ACCOUNT> --snowflake_user=<SNOWFLAKE_USER> --snowflake_password=<SNOWFLAKE_PASSWORD> --snowflake_warehouse=<SNOWFLAKE_WAREHOUSE>"
    echo
    exit 85 # Common GNU/Linux Exit Code for 'Interrupted system call should be restarted'
fi

# Check required --snowflake_user argument was supplied
if [ -z $snowflake_user ]
then
    echo
    echo "(Error Message 006)  You did not include the proper use of the --snowflake_user=<SNOWFLAKE_USER> argument in the call."
    echo
    echo "Usage:  Require all four arguments ---> `basename $0` --environment=<ENVIRONMENT_NAME> --profile=<SSO_PROFILE_NAME> --action=<create | destroy> --snowflake_account=<SNOWFLAKE_ACCOUNT> --snowflake_user=<SNOWFLAKE_USER> --snowflake_password=<SNOWFLAKE_PASSWORD> --snowflake_warehouse=<SNOWFLAKE_WAREHOUSE>"
    echo
    exit 85 # Common GNU/Linux Exit Code for 'Interrupted system call should be restarted'
fi

# Check required --snowflake_password argument was supplied
if [ -z $snowflake_password ]
then
    echo
    echo "(Error Message 007)  You did not include the proper use of the --snowflake_password=<SNOWFLAKE_PASSWORD> argument in the call."
    echo
    echo "Usage:  Require all four arguments ---> `basename $0` --environment=<ENVIRONMENT_NAME> --profile=<SSO_PROFILE_NAME> --action=<create | destroy> --snowflake_account=<SNOWFLAKE_ACCOUNT> --snowflake_user=<SNOWFLAKE_USER> --snowflake_password=<SNOWFLAKE_PASSWORD> --snowflake_warehouse=<SNOWFLAKE_WAREHOUSE>"
    echo
    exit 85 # Common GNU/Linux Exit Code for 'Interrupted system call should be restarted'
fi

# Check required --snowflake_warehouse argument was supplied
if [ -z $snowflake_warehouse ]
then
    echo
    echo "(Error Message 008)  You did not include the proper use of the --snowflake_user=<SNOWFLAKE_WAREHOUSE> argument in the call."
    echo
    echo "Usage:  Require all four arguments ---> `basename $0` --environment=<ENVIRONMENT_NAME> --profile=<SSO_PROFILE_NAME> --action=<create | destroy> --snowflake_account=<SNOWFLAKE_ACCOUNT> --snowflake_user=<SNOWFLAKE_USER> --snowflake_password=<SNOWFLAKE_PASSWORD> --snowflake_warehouse=<SNOWFLAKE_WAREHOUSE>"
    echo
    exit 85 # Common GNU/Linux Exit Code for 'Interrupted system call should be restarted'
fi

# Get the SSO AWS_ACCESS_KEY_ID, AWS_ACCESS_SECRET_KEY, AWS_SESSION_TOKEN, and AWS_REGION, and
# set them as environmental variables
aws sso login $AWS_PROFILE
eval $(aws2-wrap $AWS_PROFILE --export)
export AWS_REGION=$(aws configure get sso_region $AWS_PROFILE)
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)

# Create the RSA Keys for the Snowflake service account user
PRIVATE_KEY_WITH_HEADER_FOOTER=$(openssl genrsa 2048 | openssl pkcs8 -topk8 -inform PEM -nocrypt)
PUBLIC_KEY_WITH_HEADER_FOOTER=$(openssl rsa -in <(echo ${PRIVATE_KEY_WITH_HEADER_FOOTER}) -pubout)
RSA_PUBLIC_KEY=${PUBLIC_KEY_WITH_HEADER_FOOTER:27:398}

# Set the Snowflake environment credential variables that are
# used by Snowflalke CLI to authenticate
export SNOWFLAKE_ACCOUNT="${snowflake_account}"
export SNOWFLAKE_USER=${snowflake_user}
export SNOWFLAKE_PASSWORD=${snowflake_password}
export SNOWFLAKE_WAREHOUSE=${snowflake_warehouse}

# Create the Snowflake service account user and grant it access
# to the SYSADMIN and SECURITYADMIN roles needed for account
# management
snow sql -q "CREATE USER \"${snowflake_user}\" RSA_PUBLIC_KEY=\"${RSA_PUBLIC_KEY}\" DEFAULT_ROLE=PUBLIC MUST_CHANGE_PASSWORD=FALSE;" --temporary-connection --role ACCOUNTADMIN
snow sql -q "GRANT ROLE SYSADMIN TO USER \"${snowflake_user}\";" --temporary-connection --role ACCOUNTADMIN
snow sql -q "GRANT ROLE SECURITYADMIN TO USER \"${snowflake_user}\";" --temporary-connection --role ACCOUNTADMIN

# Create terraform.tfvars file
printf "aws_account_id=\"${AWS_ACCOUNT_ID}\"\
\naws_profile=\"${environment_name}\"\
\naws_region=\"${AWS_REGION}\"\
\naws_access_key_id=\"${AWS_ACCESS_KEY_ID}\"\
\naws_secret_access_key=\"${AWS_SECRET_ACCESS_KEY}\"\
\naws_session_token=\"${AWS_SESSION_TOKEN}\"\
\nsnowflake_account=\"${snowflake_account}\"\
\nsnowflake_authenticator=\"JWT\"\
\nsnowflake_public_key=\"${PUBLIC_KEY_WITH_HEADER_FOOTER}\"\
\nsnowflake_private_key=\"${PRIVATE_KEY_WITH_HEADER_FOOTER}\"\
\nsnowflake_user=\"${snowflake_user}\"" > terraform.tfvars

terraform init

if [ "$create_action" = true ]
then
    # Create/Update/Destroy the Terraform configuration
    terraform plan -var-file=terraform.tfvars
    terraform apply -var-file=terraform.tfvars
else
    # Force the destroy of all the AWS Secret(s) created by the Terraform configuration
    aws secretsmanager delete-secret --secret-id /snowflake_resource --force-delete-without-recovery

    # Destroy the Terraform configuration
    terraform destroy -var-file=terraform.tfvars
fi
