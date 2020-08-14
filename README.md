## API gateway with Lambda demo on Node.js

Terraform setup of API gateway with Lambda running on Node.js.

**Quick demo few AWS services and concepts:**

- AWS IAM roles (Lambda and API gateway)
- AWS API gateway
- Lambda CW logs setup 
- Lambda S3 store 
- Terraform (>= v0.12.24)

### Sections

1. [Quick Start](#quick-start)  
2. [Lambda Versioning](#lambda-versioning)  

### Quick Start

1. Setup the environment   
```sh

// create a file called setup-env.sh 
export AWS_ACCESS_KEY_ID=<your-aws-key>
export AWS_SECRET_ACCESS_KEY=<your-aws-secret>
export AWS_DEFAULT_REGION=us-east-1

. ./setup-env.sh
```

2. Create Infrastructure  

**Important:** Note down the `queue-url` of the sqs queue to be used later

```sh
# The IP address is important for instance access (This is important if you want to test with instance)
terraform init
terraform plan
terraform apply -auto-approve 
```

3. Visit Console and trigger lambda   


### Lambda Versioning 

Created custom versioning of lambda code changes via node.js scripts. The gist of it is when versioning is done through the npm (patch, minor, major) the terraform configuration will pick up changes and push changes based on the version in the `package.json`. 


**Publishing:**
```sh
// Patch
yarn run version:patch

// Minor 
yarn run version:minor

// Major 
yarn run version:major
```

**Deploying:**

```
terraform plan
terraform apply -auto-approve 
```
