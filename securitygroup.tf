/**
 * Create by : Benja kuneepong
 * Date : Wed, Aug  7, 2024  1:59:35 PM
 * Purpose : ใช้สำหรับอนุญาติให้ traffic ทั้งหมดเข้า EC2 linux ได้
 */
resource "aws_security_group" "ec2_linux_sg" {
  name        = "ec2-linux-sg-securitygroup"
  description = "Allow ssh traffic to EC2 instances"
  vpc_id      = var.vpc_id



  ingress {
    description      = "Allow ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }

 ingress {
    description      = "Allow all"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = []
    self             = true
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "ec2-linux-test-securitygroup"
  }
}

/**
 * Create by : Benja kuneepong
 * Date : Wed, Aug  7, 2024  1:59:35 PM
 * Purpose : ใช้สำหรับอนุญาติให้ traffic ทั้งหมดเข้า EC2 ด้วย protocol web ได้
 */
resource "aws_security_group" "ec2_web_sg" {
  name        = "ec2-web-sg-securitygroup"
  description = "Allow web traffic to EC2 instances"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Allow all"
    from_port        = 80
    to_port          = 80
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

#ใช้สำหรับ jenkin
   ingress {
    description      = "Allow all"
    from_port        = 8080
    to_port          = 8080
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  #ใช้สำหรับ tomcat
   ingress {
    description      = "Allow all"
    from_port        = 8081
    to_port          = 9000
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Allow all"
    from_port        = 443
    to_port          = 443
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

 

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "ec2-web-test-securitygroup"
  }
}

/**
 * Create by : Benja kuneepong
 * Date : Thu, Aug  8, 2024 12:50:07 PM
 * Purpose : ใช้สำหรับกำหนด security group สำหรับ rds mysql
 */

resource "aws_security_group" "mysq_db_sg" {
  name = "rds-mysql-test-sg"
  description = "Security group for rds mysql"
  vpc_id      = var.vpc_id

  # Allow incoming traffic from the IP address range of rds mysql
  ingress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
 
  }
  # Allow outgoing traffic to anywhere
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  tags = {
    Name = "rds-mysql-test-sg"
  }

/*
    lifecycle {
    ignore_changes = all
  }
*/
}