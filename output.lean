def aws_instance_example : Resource := {
  address := "aws_instance.example",
  type := "aws_instance",
  name := "example",
  provider_name := "registry.terraform.io/hashicorp/aws",
  values := {
    ami := "ami-0c02fb55956c7d316",
    instance_type := "t2.micro",
    tags := { ... }
}
}

