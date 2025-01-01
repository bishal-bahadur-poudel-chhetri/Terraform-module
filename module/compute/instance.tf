resource "aws_instance" "ec2_instance" {
    count = var.environment == "Production" ? 2: 1
    ami = lookup(var.amis,var.aws_region)
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = element(var.public_subnet_cidr,count.index) 
    associate_public_ip_address = true
    vpc_security_group_ids = [var.sg_id]
    depends_on = [var.elb_listener_public]
  
}