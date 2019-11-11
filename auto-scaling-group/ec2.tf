resource "aws_key_pair" "server_ssh_key" {
  public_key = file("./aws_key.pub")
}
//
//resource "aws_instance" "node_server" {
//  ami = data.aws_ami.ubuntu.id
//  instance_type = local.instance_type
//
//  key_name = aws_key_pair.server_ssh_key.key_name
//
//  subnet_id = local.subnet_a_id
//
//  vpc_security_group_ids = [aws_security_group.allow_http.id, aws_security_group.allow_tls.id, aws_security_group.allow_ssh.id]
//
//  iam_instance_profile = aws_iam_instance_profile.autoscaling-group-instance-profile.name
//}

//resource "aws_eip_association" "EIP_association" {
//  allocation_id = aws_eip.EIP_ASG.id
//  instance_id = aws_instance.node_server.id
//}


resource "aws_launch_configuration" "backend" {
  # Launch Configurations cannot be updated after creation with the AWS API.
  # In order to update a Launch Configuration, Terraform will destroy the
  # existing resource and create a replacement.
  #
  # We're only setting the name_prefix here,
  # Terraform will add a random string at the end to keep it unique.
  name_prefix = "backend-"

  image_id                    = data.aws_ami.ubuntu.id
  instance_type               = local.instance_type
  security_groups             = [aws_security_group.allow_http.id, aws_security_group.allow_ssh.id]

  iam_instance_profile = aws_iam_instance_profile.autoscaling-group-instance-profile.name

  key_name = aws_key_pair.server_ssh_key.key_name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "backend" {
  # Force a redeployment when launch configuration changes.
  # This will reset the desired capacity if it was changed due to
  # autoscaling events.
  name = "${aws_launch_configuration.backend.name}-asg"

  min_size             = 1
  desired_capacity     = 3
  max_size             = 10
  health_check_type    = "EC2"
  launch_configuration = aws_launch_configuration.backend.name
  vpc_zone_identifier  = [local.subnet_a_id]

  target_group_arns = [aws_lb_target_group.tg.arn]

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }
}
