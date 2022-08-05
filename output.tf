output "security_grp_id" {
  description = "securitygrp-id"
  value       = aws_security_group.ec2-sg.id
}
output "instance_ids" {
  description = "id"
  value       = ["${aws_instance.terraforminstance.*.id}"]
}