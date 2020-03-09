 provider "aws" {
  region = "ap-southeast-1"
}
 #Creating security group
 
 resource "aws_security_group" "web-server" {
  name = "sg"
  
   tags = { 
    Name = "Terraform-instance-security-group"
    }

# specify the inbound rules 
  
 ingress { 
      from_port = 22
      to_port   = 22
      protocol  = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
 	}

 ingress {
      from_port = 80
      to_port   = 80
      protocol  = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
	}	

 ingress {
      from_port = 443
      to_port   = 443
      protocol  = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
	}	

 } 

#Copy the public key from Local machine to remote
  resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = "${file("/home/rvd/.ssh/id_rsa.pub")}"
}

#Create AWS Instance 

 resource "aws_instance" "web" {
  ami    = "ami-07ce5f60a39f1790e"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.web-server.name}"]
   key_name = "${aws_key_pair.ssh_key.id}"


 tags = {
  Name = "Ninx-server" 
 }
}

resource "aws_eip" "lb" {
  instance = "${aws_instance.web.id}"
  vpc      = true
}

#allocating Elastic IP 

 #resource "aws_eip_association" "eip_assoc" { 
 #   instance_id = "${aws_instance.web.id}"
 #   allocation_id = "${aws_eip.example.id}"
  #   }

 #resource "aws_eip" "example" {
 #  vpc = true
 #}

 

