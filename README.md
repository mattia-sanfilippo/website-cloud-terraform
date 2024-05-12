# Website Cloud Infrastructure

## Description

This project sets up a cloud infrastructure for a website using Terraform and AWS as provider. The infrastructure includes the following components:

### VPC

The VPC is set up using the [`terraform-aws-modules/vpc/aws`](.terraform/modules/vpc/main.tf) module. It includes public and private subnets across multiple availability zones, NAT gateways, and DNS hostnames. The configuration for the VPC can be found in [vpc.tf](vpc.tf).

### EC2 Instances

EC2 instances are set up with an autoscaling group and a security group that allows HTTP ingress. The configuration for the EC2 instances can be found in [asg.tf](asg.tf).

### S3 Bucket

An S3 bucket is used to store media files. Files in the `uploads/` directory are uploaded to the bucket. The configuration for the S3 bucket can be found in [s3.tf](s3.tf).

### CloudFront Distribution

A CloudFront distribution is set up to serve the website and the S3 media bucket. The configuration for the CloudFront distribution can be found in [cloudfront.tf](cloudfront.tf).

### WAF

A Web Application Firewall (WAF) is set up for rate limiting requests to the CloudFront distribution. The configuration for the WAF can be found in [waf.tf](waf.tf).

### Variables

Various variables are used to configure the infrastructure, such as the AWS region, domain name, and S3 bucket prefix. These can be found in [variables.tf](variables.tf).

## Installation

To set up the cloud infrastructure, you will need to have Terraform installed. You can download Terraform from the [official website](https://www.terraform.io/downloads.html).

To install the required Terraform modules, run the following command:

```bash
terraform init
```

To create the cloud infrastructure, run the following command:

```bash
terraform apply
```

To destroy the cloud infrastructure, run the following command:

```bash
terraform destroy
```
