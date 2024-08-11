

#create a VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = var.azs
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

#Create Security Group
resource "aws_security_group" "my_sg" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

# create key-pair
resource "aws_key_pair" "ec2_key" {
  key_name   = "myec2-key"
  public_key = var.aws_key_pair
}

# Create EC2 instance the vpc_security_group_ids is refrence from the security resource, the subnet_id is refrence from the vpc module where [0] represent the first string of the public_subnet list. 
#To enable public IP, we enable subnet_id to true.
resource "aws_instance" "app_server" {
  ami           = "ami-03e5c370e86fd5ebb"
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  key_name      = aws_key_pair.ec2_key.key_name
  subnet_id     = module.vpc.public_subnets[0]
  associate_public_ip_address = true
 for_each = {
    k8s-control = "Instance-1"
    k8s-worker1= "Instance-2"
    k8s-worker2 = "Instance-3"
  }
 tags = {
    Name = each.key
    Numbering = each.value
  }
  }


# Lunch Template configuration
  /*resource "aws_launch_configuration" "app_server" {
  name_prefix     = "learn-terraform-aws-asg-"
  image_id        = "ami-03e5c370e86fd5ebb"
  instance_type   = var.instance_type
  user_data       = file("user-data.sh")
  security_groups = [aws_security_group.my_sg.id]

  lifecycle {
    create_before_destroy = true
  }
  }
# Autocaling Group Set up
resource "aws_autoscaling_group" "app_server" {
  min_size             = 1
  max_size             = 5
  desired_capacity     = 2
  launch_configuration = aws_launch_configuration.app_server.name
  vpc_zone_identifier  = module.vpc.public_subnets
}

# Load Balancer  Set up
resource "aws_lb" "app_server" {
  name               = "Myapp-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.my_sg.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_lb_target_group" "My_app" {
  name     = "Myapp-asg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

# Listener Set up
resource "aws_lb_listener" "app_server" {
  load_balancer_arn = aws_lb.app_server.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_serve.arn
  }
}

# Load Balancer Target Group set up
resource "aws_lb_target_group" "app_serve" {
   name     = "appserve-lb-target-group"
   port     = 80
   protocol = "HTTP"
   vpc_id   = module.vpc.vpc_id
 }

resource "aws_autoscaling_attachment" "app_serve" {
  autoscaling_group_name = aws_autoscaling_group.app_server.id
  lb_target_group_arn   = aws_lb_target_group.app_serve.arn
}

# Add Scalling Policy
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "Myapp_scale_down"
  autoscaling_group_name = aws_autoscaling_group.app_server.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 120
}

resource "aws_cloudwatch_metric_alarm" "scale_down" {
  alarm_description   = "Monitors CPU utilization for app_server ASG"
  alarm_actions       = [aws_autoscaling_policy.scale_down.arn]
  alarm_name          = "app_server_scale_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "10"
  evaluation_periods  = "2"
  period              = "120"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app_server.name
  }
}*/
