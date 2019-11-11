data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["my-amis-asg-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["self"] # Canonical
}
