//Creating a new VPC in my sandbox account
resource "aws_vpc" "vpc_terraform_demo" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "JZ_TF_VPC"
  }
}

//Creating a subnet within the new VPC we are making
resource "aws_subnet" "main_public_subnet_tf" {
  vpc_id     = aws_vpc.vpc_terraform_demo.id // Using references to reference Terraform's pointer -> Tells Terraform that the VPC needs to be created first and destroyed second
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "JZ_TF_Public_Subnet"
  }
}

//Creating an Internet Gateway that will live in the public subnet of our new VPC
resource "aws_internet_gateway" "tf_internet_gw" {
  vpc_id = aws_vpc.vpc_terraform_demo.id
}

// Creating an EC2 Instance within the subnet of the new VPC
resource "aws_instance" "ec2-terraform-demo" {
  ami           = var.ami
  instance_type = var.instance_type
  //count         = var.instance_count
  subnet_id     = aws_subnet.main_public_subnet_tf.id // Using references to reference the subnet ID we had declared previously.
  tags = {
    Name = "EC2_TF_Demo"
  }
}

// Creating a Security Group for our new EC2 Instance by utilizing dynamic blocks
resource "aws_security_group" "TF_JZ_Security_Group" {
  vpc_id = aws_vpc.vpc_terraform_demo.id
  dynamic "ingress" {    // The config block you're trying to replicate
    for_each = var.rules // A complex variable to iterate over -> Inside the dynamic block, we have a 'for_each' loop statement
    content {            // The nested 'content' block defines the body of each generated block, using the variable you provided
      from_port   = ingress.value["port"]
      to_port     = ingress.value["port"]
      protocol    = ingress.value["proto"]
      cidr_blocks = ingress.value["cidrs"]
    }
  }
  tags = {
    Name = "TF_JZ_Security_Group"
  }
}

// Attaching our newly created Security Group to our newly created EC2 Instance
resource "aws_network_interface_sg_attachment" "TF_JZ_SG_Attachment" {
  security_group_id    = aws_security_group.TF_JZ_Security_Group.id
  network_interface_id = aws_instance.ec2-terraform-demo.primary_network_interface_id
}