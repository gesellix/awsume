# Containerized AWSume

A container with AWSume and AWS CLI to manage your shell's environment and perform tasks on the AWS API.

## Usage

You can find the latest documentation for the AWS CLI at [the user guide](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)
 and the documentation for AWSume at [awsu.me](https://awsu.me/).

Please note for the examples below:
- `host>` means "perform this command in your shell"
- `awsume>` means "perform this command in the gesellix/awsume container"

### Prepare your AWS CLI config and credentials

#### Create a basic AWS CLI profile for your user

First you'll need to [create IAM user access keys](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html#Using_CreateAccessKey)
 and while you're already on your AWS user's `My Security Credentials` page, please note your MFA device's ARN.

The `aws configure` command helps creating or updating your profiles:

```shell script
host> docker run --rm -it -v ~/.aws:/root/.aws/ gesellix/awsume # run the container's shell
awsume> aws configure --profile my-account       # use the aws cli to configure your user's profile
AWS Access Key ID [None]: AWSACCESSKEYID         # ... (enter the requested details)
AWS Secret Access Key [None]: Secret+Access/Key  # ...
Default region name [None]: eu-central-1         # ...
Default output format [None]: json               # ...
awsume> [ctrl+d]                                 # exit the container
host> cat ~/.aws/config                          # verify that everything has been written to your local user's home
```

If Multi Factor Authentication (MFA) is mandatory, manually add the following entry in your profile's section at `~/.aws/config`:

> note that this example expects that there's no other entry for `mfa_serial`, yet.

```shell script
host> echo "mfa_serial = arn:aws:iam::123456789:mfa/..." >> ~/.aws/config
```

#### Add any roles you want to assume as new profiles

The `aws` CLI won't help you here - you'll have to edit your `~/.aws/config` manually. The result could look like this:

```text
[profile my-account]
region = eu-central-1
output = json
mfa_serial = arn:aws:iam::123456789:mfa/user.name

[profile dev]
role_arn = arn:aws:iam::1283847458738:role/My-DevRole
source_profile = my-account

[profile prod]
role_arn = arn:aws:iam::3894787978734:role/My-ProdRole
source_profile = my-account
```

### Manage your shell's environment

List configured profiles:

```shell script
host> docker run --rm -v ~/.aws/:/root/.aws/ gesellix/awsume awsume -l
```

Get AWS environment variables for a new session:

```shell script
host> docker run --rm -v ~/.aws/:/root/.aws/ gesellix/awsume awsume --show-commands --mfa-token 868990 dev 2> /dev/null
export AWS_ACCESS_KEY_ID=AWSACCESSKEYID
export AWS_SECRET_ACCESS_KEY=Secret+Access/Key
export AWS_SESSION_TOKEN=...==
export AWS_SECURITY_TOKEN=...==
export AWS_REGION=eu-central-1
export AWS_DEFAULT_REGION=eu-central-1
export AWSUME_PROFILE=dev
```

### Use the awsume console plugin to generate a url to the console
Related docs: https://github.com/trek10inc/awsume-console-plugin
```
host> docker run --rm -it -v ~/.aws:/root/.aws/ gesellix/awsume # run the container's shell

> awsume <profile> -cl
> awsume <profile> -csl cfn # go directly to cloudformation
```


## Build the Docker image

If you want to change the Docker image for your specific needs, you'll need to change the relevant files, e.g. `Dockerfile`, and rebuild the image:

    host> docker build -t gesellix/awsume .
