module "dev_ec2-1" {
    source =  "../module/compute"
    environment = module.dev_vpc_1.environment
    amis = {
        us-east-1 = "ami-0e2c8caa4b6378d8c"
        us-east-2 = "ami-036841078a4b68e14"
    }
    instance_type = "t2.micro"
    key_name = "bastian"
    sg_id = module.dev_sg_1.sg_id
    public_subnet_cidr = module.dev_vpc_1.public_subnet_cidr
    aws_region = var.aws_region
    elb_listener_public = module.dev_elb_1.elb_listner

}

module "dev_elb_1" {
  source          = "../module/elb"
  environment     = "Development"
  subnets         = module.dev_vpc_1.public_subnet_cidr
  aws_lb_name     = "dev-nlb-public"
  private_servers = module.dev_ec2-1.public_servers
  vpc_id          = module.dev_vpc_1.vpc_id
  lb_type         = "network" # Use "application" if ALB is required
  lgname          = "dev-nlb-lg-public"
  security_group  = module.dev_sg_1.sg_id 
}
module "dev_iam_1" {
  source              = "../module/iam"
  environment         = module.dev_vpc_1.environment
  rolename            = "TestRole"
  instanceprofilename = "TestPofile"
}