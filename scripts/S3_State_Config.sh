#!/bin/bash

# Bootstrap S3 bucket and DynamoDB table for Terraform state

BUCKET_NAME="terraform-s3-l00203120-rod"
DYNAMODB_TABLE="terraform-state-lock"
REGION="us-east-1"

# Creating S3 bucket for Terraform state.
aws s3api create-bucket \
    --bucket $BUCKET_NAME \
    --region $REGION \

# Enabling versioning
aws s3api put-bucket-versioning \
    --bucket $BUCKET_NAME \
    --versioning-configuration Status=Enabled

# Enabling encryption
aws s3api put-bucket-encryption \
    --bucket $BUCKET_NAME \
    --server-side-encryption-configuration \
    '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'

# Creating DynamoDB table for state locking
aws dynamodb create-table \
    --table-name $DYNAMODB_TABLE \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region $REGION

echo "Backend resources created successfully!"