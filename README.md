# Massdriver Serverless API Demo
Welcome to our Massdriver Serverless API Demo! 

This project showcases the power and flexibility of Massdriver in deploying a serverless architecture on AWS, leveraging key services such as AWS Lambda, API Gateway, and S3. 
This demo provides a practical and straightforward use case of a FastAPI application running within an AWS Lambda function, integrated with an API Gateway and an S3 bucket.

## Key Features
### Serverless FastAPI Application
Utilize AWS Lambda to host a containerized FastAPI application (located in /app), offering a high-performance, modern framework for building APIs with Python 3.10.

### API Gateway Integration
Seamlessly connects the Lambda function with an API Gateway, exposing scalable API endpoints for client interactions.

### S3 Bucket for Storage
Incorporate an S3 bucket for reliable and scalable object storage, enabling file upload and download functionalities within the API.

## Use Case and Value
This demo serves as an excellent example of how Massdriver can simplify the process of deploying a serverless API. By using these three bundles, you'll experience:

### Simplified Deployment
Massdriver streamlines the deployment process, making it easy to set up a serverless API with minimal configuration.

### Scalable Architecture
Embrace the benefits of a serverless architecture, including scalability and cost-efficiency, especially suitable for applications with varying load.

### Real-World API Operations
The demo includes basic but essential API operations:

A health check endpoint (/), to quickly assess the API's status.

A test endpoint (/test), to validate the API's responsiveness.

File upload (/upload) and download (/download) endpoints, showcasing real-world interactions with AWS S3.

### Ideal for Learning and Experimentation
Whether you're a developer, a student, or just someone curious about serverless architectures and cloud integrations, this demo provides a hands-on opportunity to explore these concepts. It's designed to be easily understandable and modifiable, making it an ideal starting point for your experiments with AWS services and Massdriver.

# Bundles Overview
This demo leverages three key Massdriver bundles to create a comprehensive serverless API solution. Each bundle plays a specific role in setting up and managing the underlying AWS resources efficiently. Here's a closer look at each bundle:

## API Gateway Bundle
**Repository**: [AWS API Gateway Rest API](https://github.com/massdriver-cloud/aws-apigateway-rest-api)

**Purpose**: This bundle deploys an Amazon API Gateway, which serves as the front door for our FastAPI application. It enables the creation, publishing, maintenance, and monitoring of APIs at scale.

**Functionality**: The API Gateway acts as a proxy, routing requests to our AWS Lambda function and handling responses. It is crucial for managing API traffic, and can be extended to include authorizing API calls, and controlling access.

## S3 Application Asset Bundle
**Repository**: [AWS S3 Application Asset Bucket](https://github.com/massdriver-cloud/aws-s3-application-asset-bucket)

**Purpose**: This bundle sets up an Amazon S3 bucket, providing scalable and secure object storage for our application assets.

**Functionality**: The S3 bucket is utilized by our FastAPI application for file upload and download operations. It is configured to ensure high availability, security, and performance for storing and retrieving various types of data.

## Lambda Bundle
**Repository**: You're in it! [Lambda Bundle](./lambda_bundle/)

**Purpose**: Contains the code and configuration for deploying a Lambda function that runs our [FastAPI application](./app/).

**Deployment**: Using `mass bundle publish`, this bundle is deployed to create an AWS Lambda function. This function is the serverless compute layer where the FastAPI application resides.

**Functionality**: The Lambda function executes the application code in response to HTTP requests forwarded by the API Gateway. It interacts with the S3 bucket for file operations and ensures efficient, on-demand processing of requests.

## Seamless Integration
Together, these bundles form a cohesive infrastructure, demonstrating the power and flexibility of Massdriver in deploying cloud-native applications. By abstracting the complexity of AWS resource management, Massdriver allows us to focus on developing and deploying our application logic, while it takes care of the underlying infrastructure.

## Walkthrough: Setting Up and Using the Serverless API with Massdriver

Follow these steps to set up and deploy your serverless API using Massdriver. This walkthrough assumes you have basic familiarity with AWS, Docker, and command-line operations. We've saved the Massdriver CLI commands in a [Makefile](./Makefile)

### Step 1: Massdriver Onboarding
If you're new to Massdriver, start by completing [Massdriver onboarding](https://docs.massdriver.cloud/getting-started/onboarding). This will guide you through setting up your Massdriver account and environment. Additionally, set your AWS credentials artifact ID as follows:

```
export ARTIFACT_ID=<your-artifact-id>
```
>>> SCREEN_TO_GIF_GOES_HERE

### Step 2: Clone the Repository
Clone this repository to your local machine. This will include the necessary files for the Lambda bundle and the FastAPI application.

```
git clone git@github.com:massdriver-cloud/webinar-bundle-building.git
```
### Step 3: Build and Push Docker Image
Navigate to the application directory and run the following command to build the Docker image for your FastAPI Python code and push it to Amazon ECR:

```
cd webinar-bundle-building
make mass_push
```

### Step 4: Publish the Lambda Bundle
Publish the Lambda bundle to your Massdriver Catalog. This step lints and validates the bundle before publishing.

```
make mass_publish
```

### Step 5: Configure on Massdriver Canvas
In your Massdriver dashboard, drag and drop the Lambda bundle onto the Canvas. This action will automatically generate the upstream dependencies for an S3 bucket and API Gateway.

### Step 6: Configure S3 Bucket and API Gateway
Fill out the minimal configurations for the S3 Bucket and API Gateway in the Massdriver UI. Once these resources are deployed, configure the Lambda function. Note that there are structured dependency requirements for upstream and downstream bundles.

### Step 7: Interact with Your API
Once your API is deployed, you can interact with it using curl commands. The available endpoints are /test, /upload, and /download. Here are some example commands to get you started:



### Test Endpoint
This command tests the connection to your API Gateway. Replace <gateway_hash> with your actual gateway hash.

```
curl --location --request GET 'https://<gateway_hash>.execute-api.us-east-1.amazonaws.com/live/test'
```


### Upload Endpoint
This command uploads a file to your S3 bucket via the API Gateway. Replace <gateway_hash> with your actual gateway hash.
```
curl --location --request POST 'https://<gateway_hash>.execute-api.us-east-1.amazonaws.com/live/upload' \
--header 'Content-Type: application/json' \
--data-raw '{
 "file_name": "testfile.txt",
 "content": "This is testfile.txt!"
}'
```

### Download Endpoint
This command downloads a file from your S3 bucket via the API Gateway.
```
curl --location --request GET 'https://<gateway_hash>.execute-api.us-east-1.amazonaws.com/live/download' \
--header 'Content-Type: application/json' \
--data-raw '{"file_name": "testfile.txt"}'
```