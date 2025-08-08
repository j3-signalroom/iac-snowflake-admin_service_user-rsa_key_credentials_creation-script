#!/bin/bash

#
# *** Script Syntax ***
# ./create-snowflake-admin-user-and-store-credentials.sh <create | delete> --profile=<SSO_PROFILE_NAME>
#                                                                          --snowflake_account_identifier=<SNOWFLAKE_ACCOUNT_IDENTIFIER>
#                                                                          --snowflake_user=<SNOWFLAKE_USER>  
#                                                                          --snowflake_password=<SNOWFLAKE_PASSWORD>
#                                                                          --snowflake_warehouse=<SNOWFLAKE_WAREHOUSE>
#                                                                          --secrets_root_path=<SECRETS_ROOT_PATH>
#                                                                          --new_admin_user=<NEW_ADMIN_USER>
#
#

# Check required command (create or delete) was supplied
case $1 in
  create)
    create_action=true;;
  delete)
    create_action=false;;
  *)
    echo
    echo "(Error Message 001)  You did not specify one of the commands: create | delete."
    echo
    echo "Usage:  Require all four arguments ---> `basename $0` <create | delete> --profile=<SSO_PROFILE_NAME> --snowflake_account_identifier=<SNOWFLAKE_ACCOUNT_IDENTIFIER> --snowflake_user=<SNOWFLAKE_USER> --snowflake_password=<SNOWFLAKE_PASSWORD> --snowflake_warehouse=<SNOWFLAKE_WAREHOUSE> --secrets_root_path=<SECRETS_ROOT_PATH> --new_admin_user=<NEW_ADMIN_USER>"
    echo
    exit 85 # Common GNU/Linux Exit Code for 'Interrupted system call should be restarted'
    ;;
esac

# Get the arguments passed by shift to remove the first word
# then iterate over the rest of the arguments
shift
for arg in "$@" # $@ sees arguments as separate words
do
    case $arg in
        *"--profile="*)
            AWS_PROFILE=$arg;;
        *"--snowflake_account_identifier="*)
            arg_length=21
            snowflake_account_identifier=${arg:$arg_length:$(expr ${#arg} - $arg_length)};;
        *"--snowflake_user="*)
            arg_length=17
            snowflake_user=${arg:$arg_length:$(expr ${#arg} - $arg_length)};;
        *"--snowflake_password="*)
            arg_length=21
            snowflake_password=${arg:$arg_length:$(expr ${#arg} - $arg_length)};;
        *"--snowflake_warehouse="*)
            arg_length=31
            snowflake_warehouse=${arg:$arg_length:$(expr ${#arg} - $arg_length)};;
        *"--secrets_root_path="*)
            arg_length=20
            secrets_root_path=${arg:$arg_length:$(expr ${#arg} - $arg_length)};;
        *"--new_admin_user="*)
            arg_length=17
            new_admin_user=${arg:$arg_length:$(expr ${#arg} - $arg_length)};;
    esac
done

# Check required --profile argument was supplied
if [ -z $AWS_PROFILE ]
then
    echo
    echo "(Error Message 002)  You did not include the proper use of the --profile=<AWS_SSO_SSO_PROFILE_NAME> argument in the call."
    echo
    echo "Usage:  Require all four arguments ---> `basename $0 $1` --profile=<SSO_PROFILE_NAME> --snowflake_account_identifier=<SNOWFLAKE_ACCOUNT_IDENTIFIER> --snowflake_user=<SNOWFLAKE_USER> --snowflake_password=<SNOWFLAKE_PASSWORD> --snowflake_warehouse=<SNOWFLAKE_WAREHOUSE> --secrets_root_path=<SECRETS_ROOT_PATH> --new_admin_user=<NEW_ADMIN_USER>"
    echo
    exit 85 # Common GNU/Linux Exit Code for 'Interrupted system call should be restarted'
fi

# Check required --snowflake_account_identifier argument was supplied
if [ -z $snowflake_account_identifier ]
then
    echo
    echo "(Error Message 003)  You did not include the proper use of the --snowflake_account_identifier=<SNOWFLAKE_ACCOUNT_IDENTIFIER> argument in the call."
    echo
    echo "Usage:  Require all four arguments ---> `basename $0 $1` --profile=<SSO_PROFILE_NAME> --snowflake_account_identifier=<SNOWFLAKE_ACCOUNT_IDENTIFIER> --snowflake_user=<SNOWFLAKE_USER> --snowflake_password=<SNOWFLAKE_PASSWORD> --snowflake_warehouse=<SNOWFLAKE_WAREHOUSE> --secrets_root_path=<SECRETS_ROOT_PATH> --new_admin_user=<NEW_ADMIN_USER>"
    echo
    exit 85 # Common GNU/Linux Exit Code for 'Interrupted system call should be restarted'
fi

# Check required --snowflake_user argument was supplied
if [ -z $snowflake_user ]
then
    echo
    echo "(Error Message 004)  You did not include the proper use of the --snowflake_user=<SNOWFLAKE_USER> argument in the call."
    echo
    echo "Usage:  Require all four arguments ---> `basename $0 $1` --profile=<SSO_PROFILE_NAME> --snowflake_account_identifier=<SNOWFLAKE_ACCOUNT_IDENTIFIER> --snowflake_user=<SNOWFLAKE_USER> --snowflake_password=<SNOWFLAKE_PASSWORD> --snowflake_warehouse=<SNOWFLAKE_WAREHOUSE> --secrets_root_path=<SECRETS_ROOT_PATH> --new_admin_user=<NEW_ADMIN_USER>"
    echo
    exit 85 # Common GNU/Linux Exit Code for 'Interrupted system call should be restarted'
fi

# Check required --snowflake_password argument was supplied
if [ -z $snowflake_password ]
then
    echo
    echo "(Error Message 005)  You did not include the proper use of the --snowflake_password=<SNOWFLAKE_PASSWORD> argument in the call."
    echo
    echo "Usage:  Require all four arguments ---> `basename $0 $1` --profile=<SSO_PROFILE_NAME> --snowflake_account_identifier=<SNOWFLAKE_ACCOUNT_IDENTIFIER> --snowflake_user=<SNOWFLAKE_USER> --snowflake_password=<SNOWFLAKE_PASSWORD> --snowflake_warehouse=<SNOWFLAKE_WAREHOUSE> --secrets_root_path=<SECRETS_ROOT_PATH> --new_admin_user=<NEW_ADMIN_USER>"
    echo
    exit 85 # Common GNU/Linux Exit Code for 'Interrupted system call should be restarted'
fi

# Check required --snowflake_warehouse argument was supplied
if [ -z $snowflake_warehouse ]
then
    echo
    echo "(Error Message 006)  You did not include the proper use of the --snowflake_user=<SNOWFLAKE_WAREHOUSE> argument in the call."
    echo
    echo "Usage:  Require all four arguments ---> `basename $0 $1` --profile=<SSO_PROFILE_NAME> --snowflake_account_identifier=<SNOWFLAKE_ACCOUNT_IDENTIFIER> --snowflake_user=<SNOWFLAKE_USER> --snowflake_password=<SNOWFLAKE_PASSWORD> --snowflake_warehouse=<SNOWFLAKE_WAREHOUSE> --secrets_root_path=<SECRETS_ROOT_PATH> --new_admin_user=<NEW_ADMIN_USER>"
    echo
    exit 85 # Common GNU/Linux Exit Code for 'Interrupted system call should be restarted'
fi

# Check required --secrets_root_path argument was supplied
if [ -z $secrets_root_path ]
then
    echo
    echo "(Error Message 007)  You did not include the proper use of the --secrets_root_path=<SECRETS_ROOT_PATH> argument in the call."
    echo
    echo "Usage:  Require all four arguments ---> `basename $0 $1` --profile=<SSO_PROFILE_NAME> --snowflake_account_identifier=<SNOWFLAKE_ACCOUNT_IDENTIFIER> --snowflake_user=<SNOWFLAKE_USER> --snowflake_password=<SNOWFLAKE_PASSWORD> --snowflake_warehouse=<SNOWFLAKE_WAREHOUSE> --secrets_root_path=<SECRETS_ROOT_PATH> --new_admin_user=<NEW_ADMIN_USER>"
    echo
    exit 85 # Common GNU/Linux Exit Code for 'Interrupted system call should be restarted'
fi

# Check required --new_admin_user argument was supplied
if [ -z $new_admin_user ]
then
    echo
    echo "(Error Message 008)  You did not include the proper use of the --new_admin_user=<NEW_ADMIN_USER> argument in the call."
    echo
    echo "Usage:  Require all four arguments ---> `basename $0 $1` --profile=<SSO_PROFILE_NAME> --snowflake_account_identifier=<SNOWFLAKE_ACCOUNT_IDENTIFIER> --snowflake_user=<SNOWFLAKE_USER> --snowflake_password=<SNOWFLAKE_PASSWORD> --snowflake_warehouse=<SNOWFLAKE_WAREHOUSE> --secrets_root_path=<SECRETS_ROOT_PATH> --new_admin_user=<NEW_ADMIN_USER>"
    echo
    exit 85 # Common GNU/Linux Exit Code for 'Interrupted system call should be restarted'
fi

# Set the Snowflake environment credential variables that are
# used by the Snowflalke CLI commands to authenticate
export SNOWFLAKE_ACCOUNT_IDENTIFIER="${snowflake_account_identifier}"
export SNOWFLAKE_USER=${snowflake_user}
export SNOWFLAKE_PASSWORD=${snowflake_password}
export SNOWFLAKE_WAREHOUSE=${snowflake_warehouse}

# Set the AWS environment credential variables that are used
# by the AWS CLI commands to authenicate
aws sso login $AWS_PROFILE
eval $(aws2-wrap $AWS_PROFILE --export)
export AWS_REGION=$(aws configure get sso_region $AWS_PROFILE)

# Function to handle the user creation error
user_updater_handler() {
    snow sql -q "ALTER USER ${new_admin_user} SET RSA_PUBLIC_KEY=\"`cat public_key_1.pub`\";" --temporary-connection --role ACCOUNTADMIN
    snow sql -q "ALTER USER ${new_admin_user} UNSET RSA_PUBLIC_KEY_2;" --temporary-connection --role ACCOUNTADMIN

    # Force the delete of the AWS Secret
    aws secretsmanager delete-secret --secret-id "$secrets_root_path" --force-delete-without-recovery
}

# Set the trap to catch user creation error
trap 'user_updater_handler' ERR

# Execute the create or delete action
if [ "$create_action" = true ]
then
    # Create the RSA key pair 1 for the Snowflake service account user
    openssl genrsa 2048 | openssl pkcs8 -topk8 -inform PEM -out private_key_1.p8 -nocrypt
    openssl rsa -in private_key_1.p8 -pubout -outform DER | openssl base64 -A -out public_key_1.pub
    openssl base64 -in private_key_1.p8 -A -out private_key_1.b64

    # Create the RSA key pair 2 for the Snowflake service account user
    openssl genrsa 2048 | openssl pkcs8 -topk8 -inform PEM -out private_key_2.p8 -nocrypt
    openssl rsa -in private_key_2.p8 -pubout -outform DER | openssl base64 -A -out public_key_2.pub
    openssl base64 -in private_key_2.p8 -A -out private_key_2.b64

    # Create the Snowflake service account user and grant it access
    # to the ACCOUNTADMIN role needed for account management
    snow sql -q "CREATE USER ${new_admin_user} RSA_PUBLIC_KEY=\"`cat public_key_1.pub`\" DEFAULT_ROLE=PUBLIC MUST_CHANGE_PASSWORD=FALSE;" --temporary-connection --role ACCOUNTADMIN
    snow sql -q "GRANT ROLE ACCOUNTADMIN TO USER ${new_admin_user};" --temporary-connection --role ACCOUNTADMIN
    snow sql -q "GRANT ROLE SECURITYADMIN TO USER ${new_admin_user};" --temporary-connection --role ACCOUNTADMIN
    snow sql -q "GRANT ROLE SYSADMIN TO USER ${new_admin_user};" --temporary-connection --role ACCOUNTADMIN

    # Create or Update the AWS Secret
    aws secretsmanager create-secret --name "$secrets_root_path" --secret-string "{\"snowflake_account_identifier\":\"$snowflake_account_identifier\",\"new_admin_user\":\"$new_admin_user\",\"snowflake_organization_name\":\"${snowflake_account_identifier%-*}\",\"snowflake_account_name\":\"${snowflake_account_identifier#*-}\",\"active_key_number\":1,\"snowflake_rsa_public_key_1_pem\":\"`cat public_key_1.pub`\",\"snowflake_rsa_public_key_2_pem\":\"`cat public_key_2.pub`\",\"snowflake_rsa_private_key_pem_1\":\"`cat private_key_1.b64`\",\"snowflake_rsa_private_key_pem_2\":\"`cat private_key_2.b64`\"}"

    # Remove the RSA key pairs
    rm private_key_1.p8
    rm public_key_1.pub
    rm private_key_1.b64
    rm private_key_2.p8
    rm public_key_2.pub
    rm private_key_2.b64
else
    # Drop the Snowflake accountadmin user
    snow sql -q "DROP USER IF EXISTS ${new_admin_user};" --temporary-connection --role ACCOUNTADMIN

    # Force the delete of the AWS Secret
    aws secretsmanager delete-secret --secret-id "$secrets_root_path" --force-delete-without-recovery
fi
