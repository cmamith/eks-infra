module "vpc" {
  source = "../../../modules/vpc"

  vpc_cidr = "10.0.0.0/16"

  public_subnet_cidrs = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24"
  ]

  private_subnet_cidrs = [
    "10.0.11.0/24",
    "10.0.12.0/24",
    "10.0.13.0/24"
  ]

  enable_nat_gateway = true

  tags = {
    Project = "eks-3tier"
    Env     = "dev"
  }
}
# replan

module "eks" {
  source = "../../../modules/eks"

  cluster_name       = "dev-eks"
  cluster_version    = "1.30"

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids

  node_group_name     = "dev-ng"
  node_instance_types = ["t3.medium"]

  node_desired_size = 2
  node_min_size     = 2
  node_max_size     = 4

  tags = {
    Project = "eks-3tier"
    Env     = "dev"
  }
}

# test
