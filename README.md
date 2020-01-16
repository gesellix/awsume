## Example Flow

Create AWS environment variables with a current session:

    host> docker build -t gesellix/awsume .
    host> docker run --rm -it -v ~/.aws/:/root/.aws/ gesellix/awsume
    awsume> awsume -l
    awsume> awsume pku-admin-dev
    awsume> env | grep AWS | sort
