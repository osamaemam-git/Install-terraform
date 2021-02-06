provider "aws" {
  region     = "your_region"
  access_key = "your_access_key_credentials"
  secret_key = "your_secret_key_credentials"
}

module "elb_http" {
  source  = "terraform-aws-modules/elb/aws"
  version = "~> 2.0"

  name = "elb-test"

  subnets         = ["your_subnet_ID"]
  security_groups = ["your_security_group_ID"]
  internal        = false

  listener = [
    {
      instance_port     = "80"
      instance_protocol = "HTTP"
      lb_port           = "80"
      lb_protocol       = "HTTP"
    },
  ]

  health_check = {
    target              = "HTTP:80/"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }

  access_logs = {
    bucket = "my-access-logs-bucket"
  }

  // ELB attachments
  number_of_instances = 2
  instances           = ["i-0583f0b5f2113d274", "i-0e770d2d268663c52"]

  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}

module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  name = "service

  # Launch configuration
  lc_name = "Config-launch-test"

  image_id        = "ami image"
  instance_type   = "type instance (ex :t2.micro)"
  security_groups = ["your_security_group_ID"]

  ebs_block_device = [
    {
      device_name           = "/dev/xvdz"
      volume_type           = "gp2"
      volume_size           = "50"
      delete_on_termination = true
    },
  ]

  root_block_device = [
    {
      volume_size = "50"
      volume_type = "gp2"
    },
  ]

  # Auto scaling group
  asg_name                  = "Groupe Auto-Scaling test"
  vpc_zone_identifier       = ["your_subnet_id", "your_subnet_ID"]
  health_check_type         = "EC2"
  min_size                  = 2
  max_size                  = 4
  desired_capacity          = 2
  wait_for_capacity_timeout = 0

  tags = [
    {
      key                 = "Environment"
      value               = "dev"
      propagate_at_launch = true
    },
    {
      key                 = "Project"
      value               = "Cluster"
      propagate_at_launch = true
    },
  ]
}
