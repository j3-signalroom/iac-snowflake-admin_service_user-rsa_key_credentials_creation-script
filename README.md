# Snowflake Admin User RSA Key Credentials Creation Script

**Enhancing Efficiency and Security with Automated Snowflake User Management**

J3 has developed a script to dramatically improve both the efficiency and security of operations at signalRoom.  This script focuses on simplifying the process of creating Snowflake admin users who utilize key pair authentication.  These admin users will in the future be responsible for creating service account users.

### Key Features and Benefits:

1. **Automated RSA Key Pair Generation:**
   - The script automates the creation of RSA key pairs, which are essential for authenticating the Snowflake user.  By handling this automatically, the script eliminates manual steps, making it easier for developers to integrate and manage Snowflake resources through Terraform or other Snowflake clients.
   - This automation streamlines the authentication process, reducing setup time and potential errors, thereby enabling faster and more reliable deployment of Snowflake services.

2. **Minimal required permissions:**
   - The script grants the smallest set of privileges that the admin user needs to perform its required actions. This approach is part of the principle of *least privilege*, a security best practice that minimizes the potential for unauthorized access or accidental modifications by limiting permissions to only what is necessary.  Below is the list of roles that will be granted to the admin user:

      Role|Description
      -|-
      `ACCOUNTADMIN`|The `ACCOUNTADMIN` role in Snowflake is the highest-level administrative role within a Snowflake account. It has full control over all objects, resources, and configurations within the account. This role is responsible for managing all aspects of the Snowflake environment, including user access, resource allocation, and security settings.
      `SECURITYADMIN`|The `SECURITYADMIN` role in Snowflake is a built-in system role designed to manage security-related tasks, primarily concerning user and role management. The `SECURITYADMIN` role has elevated privileges that allow it to control access within a Snowflake account, making it one of the key roles for maintaining the security posture of a Snowflake environment.
      `SYSADMIN`|The `SYSADMIN` role in Snowflake is one of the predefined system roles that comes with a broad set of administrative privileges. It is designed to provide comprehensive control over most Snowflake resources, such as databases, schemas, warehouses, and other objects within an account. The `SYSADMIN` role is typically used for database administrators who manage the creation and configuration of Snowflake resources and control access to them.

3. **Secure Storage in AWS Secrets Manager:**
   - User information and RSA key pairs are securely stored in AWS Secrets Manager.  This ensures that sensitive data is protected while remaining easily accessible for future use without needing to compromise security.
   - The integration with AWS Secrets Manager supports secure key management practices, safeguarding against unauthorized access and simplifying the retrieval of credentials when needed.

4. **Support for Key-Pair Rotation:**
   - To adhere to best practices in security, the script creates two RSA key pairs for each Snowflake user. This approach supports seamless key rotation, allowing one key to be replaced while the other remains active.
   - The decision to generate only two key pairs aligns with Snowflake's current limitation, which allows associating a maximum of two RSA public keys per user.  This ensures compliance with Snowflake's capabilities while maintaining robust security protocols.

### Motivation and Broader Impact:

- **Streamlined Admin User Creation:**
   - The primary motivation behind this script is to streamline the entire process of creating admin users. By bundling all necessary steps into one comprehensive solution, one doesn't have to put all the puzzle pieces together alone; it is already done for you (i.e., creating the RSA key pairs, creating the snowflake admin user, and granting the minimal required permissions needed).
   - This approach not only enhances security by reducing credential exposure but also reflects a commitment to delivering efficient, all-in-one solutions for managing cloud resources.

### Commitment to Excellence and Security:

- **Innovative and Secure Solutions:**
   - This script embodies a dedication to excellence and continuous improvement, aiming to find more effective ways to manage cloud infrastructure.  By focusing on automation and secure key management, J3 is contributing to a more secure, efficient, and scalable environment at signalRoom.

**Table of Contents**

<!-- toc -->
+ [1.0 Let's get started!](#10-lets-get-started)
    - [1.1 Snowflake](#11-snowflake)
    - [1.2 AWS Secrets Manager Secrets](#12-aws-secrets-manager-secrets)
        + [1.2.1 `/snowflake_admin_credentials`](#121-snowflake_admin_credentials)
        + [1.2.2 `/snowflake_admin_credentials/rsa_private_key_pem_1`](#122-snowflake_admin_credentialsrsa_private_key_pem_1)
        + [1.2.3 `/snowflake_admin_credentials/rsa_private_key_pem_2`](#123-snowflake_admin_credentialsrsa_private_key_pem_2)
<!-- tocstop -->

## 1.0 Let's get started!

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
    git clone https://github.com/j3-signalroom/create-snowflake_admin_user-with_rsa_key_pair_authentication.git
    ```

3. From the root folder of the `create-snowflake_admin_user-with_rsa_key_pair_authentication/` repository that you cloned, run the script in your Terminal to create the Snowflake user:
    ```shell
    ./create-admin-service-account-user.sh <create | delete> --profile=<SSO_PROFILE_NAME> \
                                                             --snowflake_account=<SNOWFLAKE_ACCOUNT> \
                                                             --snowflake_user=<SNOWFLAKE_USER> \
                                                             --snowflake_password=<SNOWFLAKE_PASSWORD> \
                                                             --snowflake_warehouse=<SNOWFLAKE_WAREHOUSE> \
                                                             --admin_user=<ADMIN_USER>
    ```
    Argument placeholder|Replace with
    -|-
    `<SSO_PROFILE_NAME>`|your AWS SSO profile name for your AWS infrastructue that houses your AWS Secrets Manager.
    `<SNOWFLAKE_ACCOUNT>`|your organization's [Snowflake account identifier](https://docs.snowflake.com/en/user-guide/admin-account-identifier).
    `<SNOWFLAKE_USER>`|your Snowflake username that has been granted `ACCOUNTADMIN` privileges.
    `<SNOWFLAKE_PASSWORD>`|your Snowflake password of the `<SNOWFLAKE_USER>`.
    `<SNOWFLAKE_WAREHOUSE>`|your Snowflake warehouse is the virtual cluster of compute resources that provides CPU, memory, and temporary storage to perform DML (Data Management Language) operations.
    `<ADMIN_USER>`|the name of the new Snowflake ACCOUNTADMIN user to be created or updated.


After the script successfully runs it creates the following in Snowflake and the AWS Secrets Manager for you:

### 1.1 Snowflake
Below is a picture of an example Snowflake admin user created with the `ACCOUNTADMIN` role granted by the script:
![admin-svc-user-detail-view-screenshot](.blog/images/admin-svc-user-detail-view-screenshot.png)

### 1.2 AWS Secrets Manager Secrets
Here is the list of secrets generated by the Terraform script:

#### 1.2.1 `/snowflake_admin_credentials`
> Key|Description
> -|-
> `account`|your organization's [Snowflake account identifier](https://docs.snowflake.com/en/user-guide/admin-account-identifier).
> `admin_user`|the Snowflake admin user that administratives current and future service account users.
> `active_rsa_public_key_number`|The current active RSA public key number.
> `rsa_public_key_1`|the `admin_user` RSA public key 1.
> `rsa_public_key_2`|the `admin_user` RSA public key 2.

#### 1.2.2 `/snowflake_admin_credentials/rsa_private_key_pem_1`
The admin RSA private key PEM 1.

#### 1.2.3 `/snowflake_admin_credentials/rsa_private_key_pem_2`
The admin RSA private key PEM 2.