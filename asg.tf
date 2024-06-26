# Create a security group for EC2 instances to allow ingress on port 80:
resource "aws_security_group" "ec2_ingress" {
  name        = "ec2_http_ingress"
  description = "Uset for autoscale group"
  vpc_id      = module.vpc.vpc_id

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
}

# create launch configuration for ASG
resource "aws_launch_configuration" "asg_launch_conf" {
  name_prefix     = "tf-cloudfront-alb-"
  image_id        = data.aws_ami.ubuntu_ami.id
  instance_type   = "t2.micro"
  user_data       = data.template_cloudinit_config.user_data.rendered
  security_groups = [aws_security_group.ec2_ingress.id]
  lifecycle {
    create_before_destroy = true
  }
}

# create ASG with launch configuration
resource "aws_autoscaling_group" "asg" {
  name                 = "tf-cloudfront-alb-asg"
  launch_configuration = aws_launch_configuration.asg_launch_conf.name
  min_size             = 3
  max_size             = 10
  vpc_zone_identifier  = module.vpc.private_subnets # private subnets
  target_group_arns    = [aws_lb_target_group.alb_tg.arn]
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    module.vpc,
    aws_lb_target_group.alb_tg,
    aws_launch_configuration.asg_launch_conf
  ]
}