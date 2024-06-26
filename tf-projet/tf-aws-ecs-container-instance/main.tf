#---------------------------------------
# IAM role for ECS container instances
#---------------------------------------

#resource "aws_iam_role" "instance_role" {
#  name               = "${var.name}-container-instance-role"
#  assume_role_policy = <<EOF
#{
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Sid": "TrustEC2",
#      "Action": "sts:AssumeRole",
#      "Principal": {
#        "Service": "ec2.amazonaws.com"
#      },
#      "Effect": "Allow"
#    }
#  ]
#}
#EOF
#}
#
#resource "aws_iam_policy" "ecs_cloudwatch_logs_policy" {
#  name   = "${var.name}-cloudwatch-logs-policy"
#  policy = <<EOF
#{
#    "Version": "2012-10-17",
#    "Statement": [
#        {
#            "Effect": "Allow",
#            "Action": [
#                "logs:CreateLogGroup",
#                "logs:CreateLogStream",
#                "logs:PutLogEvents",
#                "logs:DescribeLogStreams"
#            ],
#            "Resource": [
#                "arn:aws:logs:*:*:*"
#            ]
#        }
#    ]
#}
#EOF
#}
#
#resource "aws_iam_role_policy_attachment" "ecs_cloudwatch_logs_policy_attachment" {
#  role       = aws_iam_role.instance_role.id
#  policy_arn = aws_iam_policy.ecs_cloudwatch_logs_policy.arn
#}
#
#resource "aws_iam_role_policy_attachment" "ec2_container_service_policy_attachment" {
#  role       = aws_iam_role.instance_role.id
#  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
#}
#
#resource "aws_iam_role_policy_attachment" "ec2_ssm_policy" {
#  role       = aws_iam_role.instance_role.id
#  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
#}

#-------------------------
# EC2 instance userdata
#-------------------------

data "template_file" "userdata" {
  template = file("${path.module}/userdata.tpl")

  vars = {
    cluster_name = var.ecs_cluster_name
  }
}

#----------------------------
#  Launch configuration
#----------------------------

resource "aws_launch_configuration" "lc" {
  name_prefix                 = "${var.name}-lc-"
  # using splat syntax to fix eager evaluation of data reference
  image_id                    = "ami-057f57c2fcd14e5f4"
  instance_type               = var.lc_instance_type
  key_name                    = var.lc_key_pair_name
  security_groups             = var.lc_security_group_ids
  user_data                   = var.lc_userdata == "" ? data.template_file.userdata.rendered : var.lc_userdata
  associate_public_ip_address = var.lc_associate_public_ip_address
  enable_monitoring           = true
  iam_instance_profile        = var.lab_instance_profile

  lifecycle {
    create_before_destroy = true
  }
}


#------------------
#   ASG
#------------------

resource "aws_autoscaling_group" "asg" {
  name                 = "${aws_launch_configuration.lc.id}-asg"
  launch_configuration = aws_launch_configuration.lc.name
  min_size             = var.asg_min_size
  max_size             = var.asg_max_size
  # Changing desired capacity will interfere with autoscaling
  #desired_capacity     = "${var.asg_desired_size}"
  vpc_zone_identifier  = var.asg_subnet_ids
  health_check_type    = "EC2"
  default_cooldown     = var.asg_default_cooldown

  lifecycle {
    create_before_destroy = true
  }

  enabled_metrics      = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances"
  ]

  tag {
    key                 = "Name"
    value               = "${aws_launch_configuration.lc.id}-asg"
    propagate_at_launch = "true"
  }
}
