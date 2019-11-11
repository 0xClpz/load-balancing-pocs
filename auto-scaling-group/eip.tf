resource "aws_eip" "EIP_ASG" {
  vpc = true
}

output "SSH_command" {
  value = "ssh ubuntu@${aws_eip.EIP_ASG.public_ip} -i ./aws_key"
}
