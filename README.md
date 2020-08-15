## API gateway with Lambda demo on Node.js

Terraform setup of API gateway with Lambda running on Node.js.

**Quick demo few AWS services and concepts:**

- AWS IAM roles (Lambda and API gateway)
- AWS API gateway
- Lambda CW logs setup 
- Lambda S3 store 
- Terraform (>= v0.12.24)

**Folder structure:**  

```sh
pet/
├── create.js - create new pet
├── get.js    - get pet by id
└── list.js   - list pets
```

### Sections

1. [Quick Start](#quick-start)  
2. [Lambda Versioning](#lambda-versioning)  
3. [Testing The API](#testing-the-api)  
- GET `/pets` [List Pets](#list-pets)  
- GET `/pet/:id` [Get pet by ID](#get-pet-by-id)  
- POST `/pets` [Create new pet](#create-pet)  

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

```sh
terraform init
terraform plan
terraform apply -auto-approve 

# init the dist files for lambda
yarn run version:patch
```

3. See Instructions below for testing the api.


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

### Testing The API


#### List Pets 

**Request:**  
```sh
curl -X GET "<output-api-gateway-invoke-url>/pets"
```

**Response:**  
```sh
[
    {
        "id": 1,
        "price": 249.99,
        "type": "dog"
    },
    {
        "id": 2,
        "price": 124.99,
        "type": "cat"
    },
    {
        "id": 3,
        "price": 0.99,
        "type": "fish"
    }
]
```

#### Get pet by ID:

**Request:**    

```
curl -X GET "<output-api-gateway-invoke-url>/pets/:petId"

```

**Response:**  

```sh
curl -X GET "<output-api-gateway-invoke-url>/pets/1"

[
    {
        "id": 1,
        "price": 249.99,
        "type": "dog"
    }
]
```

#### Create pet:

**Note:** All the data is in memory so there will be no persistence between lambda requests (ie. creating this endpoint will not update the list `pets` endpoint)

**Request:**    

```
curl -X POST "<output-api-gateway-invoke-url>/stage/pets" \

--data-raw '{
    "pet": {
        "id": {
            "id": 4,
            "type": "Snake",
            "price": 399.99
        }
    }
}'
```

**Response:**  

```sh
[
  {
    "id": 1,
    "type": "dog",
    "price": 249.99
  },
  {
    "id": 2,
    "type": "cat",
    "price": 124.99
  },
  {
    "id": 3,
    "type": "fish",
    "price": 0.99
  },
  {
    "id": {
      "id": 4,
      "type": "Snake",
      "price": 399.99
    }
  }
]
```
