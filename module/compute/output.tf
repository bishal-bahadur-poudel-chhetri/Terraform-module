

output public_servers {
  value       = "${aws_instance.ec2_instance.*.id}"
}