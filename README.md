# terraform-aws-modules

Terraform repository for AWS infrastructure modules and a simple root stack.

Current module status:
- `modules/vpc`: usable after the networking fixes in this branch.
- `modules/rds`: mostly implemented, with configurable parameter group family support.
- `modules/eks`: placeholder only.

Current root stack:
- Provisions a VPC from the local `modules/vpc` module.
- Uses variable defaults in [`variables.tf`](/Users/ravinder/devops/terraform-aws-modules/variables.tf) for a small `ap-south-1` layout.

Basic workflow:
```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan
```

Notes:
- Configure a real remote backend in `backend.tf` before using this outside local development.
- The `environments/` directories are placeholders and are not wired yet.
