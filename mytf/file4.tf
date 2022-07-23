 ## Moved in provider.tf file
  
 #provider "aws" {
 #access_key = "AKIA2JCT65IJZYVD3B73"
 #secret_key = "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"
 #region = "us-east-1"
#}

#########################################################


variable "key_name" {
 description = "18july"
default = "18july"
}

 variable "username" {
 description = "ubuntu"
default = "ubuntu"
}


resource "time_sleep" "wait_10_seconds" {
  create_duration = "10s"
}

resource "null_resource" "health_check" {
    
  ##########################################
  depends_on = [aws_instance.ansibleM , aws_instance.ansibleW]
  ##########################################
  
  provisioner "local-exec" {
 
    
      command = <<EOF
	cat id_rsa
	 sleep 10
  	 echo  "=============================Null resource  Begin ==================="
	  
		   cd ~/myscripts
		   cp ~/.ssh/id_rsa  ../myscripts/
		   echo "============="
		   cat ~/myscripts/masternode
		   echo "============="
		   cat ~/myscripts/iplist
		   echo "============="
		   cat ~/myscripts/id_rsa
		   echo "============="
		   
		   
		   rm  ~/myscripts/ansiconf	
		   touch  ~/myscripts/ansiconf	
		   
		    echo "============="
		   echo "[web]" >>  ~/myscripts/ansiconf
		   cat  ~/myscripts/masternode >>  ~/myscripts/ansiconf
		   
		   echo "[app]" >>  ~/myscripts/ansiconf
		   cat ~/myscripts/iplist >>  ~/myscripts/ansiconf
		   
		    echo "============="
		   cat ~/myscripts/ansiconf	
		    echo "============="
			
			
			cp ~/mytf/my_tf_keyW.pem  ~/myscripts/
			cp ~/mytf/my_tf_keyM.pem  ~/myscripts/
		   
		   echo "====Execution start of shell script ========="
		   
		   /bin/bash   ssh_ubuntu_t.sh  ~/myscripts/id_rsa    masternode
		  
          echo  "=============================Null resource  End ==================="	  
		  
		   EOF
  }
}

 

resource "aws_key_pair" "my_blog_keyM" {
  key_name = "my_tf_keyM"
  public_key = file("/home/ubuntu/.ssh/id_rsa.pub")
  #public_key = tls_private_key.pkM.public_key_openssh
}

resource "aws_key_pair" "my_blog_keyW" {
  key_name = "my_tf_keyW"
  public_key = file("/home/ubuntu/.ssh/id_rsa.pub")
  #public_key = tls_private_key.pkW.public_key_openssh
}


resource "tls_private_key" "pkM" {
  algorithm = "RSA"

}
resource "tls_private_key" "pkW" {
  algorithm = "RSA"
}
  

resource "local_file" "ssh_keyM" {
  filename = "${aws_key_pair.my_blog_keyM.key_name}.pem"
  content = tls_private_key.pkM.private_key_pem 
   
}

resource "local_file" "ssh_keyW" {
  filename = "${aws_key_pair.my_blog_keyW.key_name}.pem"
  content = tls_private_key.pkW.private_key_pem
}


####================================================================

resource "aws_security_group" "default" {
 name = "instance_sgW"
 description = "Used in the terraform"
# vpc_id = aws_vpc.default.id
 # SSH access from anywhere
 ingress {
 from_port = 22
 to_port = 22
 protocol = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
 }
 # HTTP access from anywhere
 ingress {
 from_port = 0
 to_port = 0
 protocol = -1
 cidr_blocks = ["0.0.0.0/0"]
 }
 # HTTP access from anywhere
 ingress {
 from_port = 80
 to_port = 80
 protocol = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
 }
 # outbound internet access
 egress {
 from_port = 0
 to_port = 0
 protocol = "-1"
 cidr_blocks = ["0.0.0.0/0"]
 }
}



resource "aws_security_group" "defaultM" {
 name = "instance_sg"
 description = "Used in the terraform"
# vpc_id = aws_vpc.default.id
 # SSH access from anywhere
 ingress {
 from_port = 22
 to_port = 22
 protocol = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
 }
 # HTTP access from anywhere
 ingress {
 from_port = 0
 to_port = 0
 protocol = -1
 cidr_blocks = ["0.0.0.0/0"]
 }
 # outbound internet access
 egress {
 from_port = 0
 to_port = 0
 protocol = "-1"
 cidr_blocks = ["0.0.0.0/0"]
 }
}


####================================================================
 


####=======================Master Start=========================================


resource "aws_instance" "ansibleM" {
count = 1     
 ami = lookup(var.ec2_ami,var.region) 
 instance_type = "t2.micro"
 
 #key_name = var.key_name
 key_name = aws_key_pair.my_blog_keyM.key_name
 
 security_groups =["instance_sg"]
 tags = { Name = "Ansible-Master-${count.index}" }
 #associate_public_ip_address = true
 
 
 provisioner "local-exec" {
        command = <<EOF
		  echo "Inside master node......."
		
		  
		  rm ~/myscripts/masternode
	      rm   ~/myscripts/iplist
			
          touch 	~/myscripts/masternode
		  chmod 0777 ~/myscripts/masternode
		  
		  touch 	~/myscripts/iplist
		  chmod 0777 ~/myscripts/iplist
	 
		  echo "========================"
		  echo " Master - public_ip : ${self.public_ip} "
		   
		  echo "========================"
		  
		  echo "${self.public_ip}"   | sudo -S tee -a ~/myscripts/masternode
			
		   echo "========================"
		  echo "After masternode"
		  cat ~/myscripts/masternode
			 
		   echo " Done master node......."
		   
		 
		   
		EOF
   }

 
 
}


####==========================Master End======================================

variable "ec2_ami" {
  type = map

  default = {
    us-east-1 = "ami-052efd3df9dad4825"
    us-east-1 = "ami-052efd3df9dad4825"
  }
}
variable "region" {
  default = "us-east-1"
}
variable "instance_types" {
  default = "t2.micro"
}
# Creating a Variable for instance_type
variable "instance_type" {    
  type = string
}


####=========================Worker Start=======================================
 
resource "aws_instance" "ansibleW" {
count = 2    
 ami = lookup(var.ec2_ami,var.region) 
 instance_type = "t2.micro"
 #key_name = var.key_name
 key_name = aws_key_pair.my_blog_keyM.key_name
 #key_name = aws_key_pair.kpW.key_name
 security_groups =["instance_sgW"]
 associate_public_ip_address = true
 tags = { Name = "Ansible-Worker-${count.index}" }
 
 depends_on = [aws_instance.ansibleM]
 
 connection {
    type = "ssh"
	user = "${var.username}"
	private_key = "${file("~/.ssh/id_rsa")}"
	host        = "${self.public_ip}"
	timeout = "1m"
  }
  
 
 provisioner "local-exec" {
     
	command = <<EOF
		  echo "Inside worker node......."
		  sleep 10
		  
		  echo "========================"
		  echo "Before - iplist"
 		  cat ~/myscripts/iplist
		  
		  echo "========================"
		  echo " Worker - public_ip : ${self.public_ip} "
		   
		  echo "========================"
		    
		  echo "${self.public_ip}"   | sudo -S tee -a ~/myscripts/iplist
		   
		  echo "After - iplist"
		  cat ~/myscripts/iplist
		  
		   echo " Done worker node......."
		   
		   
	EOF

    }
	
	  
	
	
}
######======================Worker End==============================

