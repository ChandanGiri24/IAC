
# EC2Instance
resource "aws_instance" "terraforminstance" {
  ami                         = var.ami_id
  availability_zone           = data.aws_availability_zones.available
  instance_type               = var.instance_type
  count                       = var.instance_count
  security_groups             = ["${aws_security_group.ec2-sg.id}"]
  iam_instance_profile        = "${aws_iam_instance_profile.web_instance_profile.name}"
  subnet_id                   = var.subnet_id
  user_data                   = file("userdata.tpl")
  associate_public_ip_address = true
  lifecycle {
    ignore_changes            = [subnet_id, ami]
  }

  root_block_device {
      volume_type           = "gp3"
      volume_size           = var.ebs_root_size_in_gb
      encrypted             = false
      delete_on_termination = true
  }
  tags = var.tags
}

#Load Balancer
resource "aws_lb" "alb" {
  name               = "emp-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.lb_logs.bucket
    prefix  = "test-lb"
    enabled = true
  }

  tags = {
    Environment = "Development"
  }
}

#Listener1
resource "aws_alb_listener" "listener_http" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.group.arn}"
    type             = "forward"
  }
}

#Listener2
resource "aws_alb_listener" "listener_https" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${var.certificate_arn}"
  default_action {
    target_group_arn = "${aws_alb_target_group.group.arn}"
    type             = "forward"
  }
}

#Target Group
resource "aws_alb_target_group" "group" {
  name     = "terraform-emp-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.vpc.id}"
  stickiness {
    type = "lb_cookie"
  }
  health_check {
    path = "/login"
    port = 80
  }
}

#Target Group Attachment
resource "aws_lb_target_group_attachment" "emp_tg_attach" {
  target_group_arn = aws_lb_target_group.group.arn
  target_id        = aws_instance.terraforminstance.id
  port             = 80
}
