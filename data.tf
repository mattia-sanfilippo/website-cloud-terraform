# fetch ubuntu image ami id from aws by filtering the image name
# owner id is Canonical
data "aws_ami" "ubuntu_ami" {
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  most_recent = true
  owners      = ["099720109477"]
}

# user data that will be used to install apache and create a simple index.html file
data "template_cloudinit_config" "user_data" {
  gzip          = false
  base64_encode = true
  part {
    content_type = "text/x-shellscript"
    content      = <<-EOT
        #!/bin/bash
        sudo apt-get update
        sudo apt-get install -y apache2
        sudo systemctl start apache2
        sudo systemctl enable apache2
        echo "<h1>Hello, World!</h1>" | sudo tee /var/www/html/index.html

        EOT
  }
}

# data source to generate bucket policy to let OAI get objects:
data "aws_iam_policy_document" "media_bucket_policy_document" {
  statement {
    actions = ["s3:GetObject"]

    resources = [
      aws_s3_bucket.media_bucket.arn,
      "${aws_s3_bucket.media_bucket.arn}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.media_oai.iam_arn]
    }
  }
}


# data source to fetch hosted zone info from domain name
data "aws_route53_zone" "hosted_zone" {
  name = var.domain_name
}