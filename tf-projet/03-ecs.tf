resource "aws_ecs_cluster" "ecs_cluster" {
  name = "cluster"
}

module "cluster_instances" {
  source                = "./tf-aws-ecs-container-instance"
  name                  = "cluster_instance"
  ecs_cluster_name      = "${aws_ecs_cluster.ecs_cluster.name}"
  lc_instance_type      = "t2.micro"
  lc_security_group_ids = [aws_security_group.main_security_group.id]
  asg_subnet_ids        = [aws_subnet.public-subnet-a.id, aws_subnet.public-subnet-b.id, aws_subnet.private-subnet-a.id, aws_subnet.private-subnet-b.id]
  lab_role              = var.lab_role
  lab_instance_profile  = var.lab_instance_profile
  depends_on = [aws_nat_gateway.private_nat_gateway]
}


