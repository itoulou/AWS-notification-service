# Mini project - AWS notification service

Beginning of a series of experimentation projects. I had already used the AWS management console to create the 
same project and resources but I want to attempt the same thing with IaC using Terraform.

### Resources used
```
. S3 Bucket
. Lambda function
. SQS
. SNS
. IAM Roles
```

### Journey
File uploaded to the bucket triggers a lambda function which sends meta data to the queue 
notifies me via email about the file being uploaded.