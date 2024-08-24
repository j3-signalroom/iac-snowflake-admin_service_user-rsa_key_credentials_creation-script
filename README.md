# IaC Initialize Terraform Snowflake User
J3 has crafted this script to significantly enhance the efficiency and security of his work at signalRoom.  By simplifying the creation of Terraform Snowflake users and automating the generation of RSA Keys, this tool empowers users to seamlessly manage Snowflake resources through Terraform. The script securely stores user information and RSA Keys in AWS Secrets Manager, ensuring safe and easy reuse without compromising security.

The motivation behind this innovation stems from a desire to streamline the entire process of creating service accounts.  J3 aimed to bundle all necessary steps into a comprehensive solution, eliminating the need to store the original `ACCOUNTADMIN` credentials when setting up a new service account. This script reflects a commitment to excellence, security, and the continual pursuit of more effective ways to manage cloud resources.

## Let's get started!

1. Take care of the cloud and local environment prequisities listed below:
    > You need to have the following cloud accounts:
    > - [AWS Account](https://signin.aws.amazon.com/) *with SSO configured*
    > - [`aws2-wrap` utility](https://pypi.org/project/aws2-wrap/#description)
    > - [Snowflake Account](https://app.snowflake.com/)

    > You need to have the following installed on your local machine:
    > - [AWS CLI version 2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
    > - [Snowflake CLI](https://docs.snowflake.com/en/developer-guide/snowflake-cli-v2/index)

2. Clone the repo:
    ```shell
    git clone https://github.com/j3-signalroom/iac-initialize-tf_snowflake_user.git
    ```

3. From the root folder of the `iac-initialize-tf_snowflake_user/` repo you cloned, run the script:
    ```shell
    ./init-tf-snowflake-user.sh <create | delete> --profile=<SSO_PROFILE_NAME> \
                                                  --snowflake_account=<SNOWFLAKE_ACCOUNT> \
                                                  --snowflake_user=<SNOWFLAKE_USER> \
                                                  --snowflake_password=<SNOWFLAKE_PASSWORD> \
                                                  --snowflake_warehouse=<SNOWFLAKE_WAREHOUSE>
    ```