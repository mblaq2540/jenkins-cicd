# /**
#  * Create by : Benja kuneepong
#  * Date : Wed, Aug  7, 2024  1:59:35 PM
#  * Purpose : สร้าง key pair สำหรับ EC2
#  */
resource "aws_key_pair" "ec2-instance" {
  key_name   = "ec2-instance"
  public_key = ""




}
/**
 * Create by : Benja kuneepong
 * Date : Wed, Aug  7, 2024  1:59:35 PM
 * Purpose : สร้าง EC2 
 */
resource "aws_instance" "ec2-instance" {
  ami                         = var.ec2_instance_image
  instance_type               = var.ec2_instance_type
  associate_public_ip_address = true

  key_name               = aws_key_pair.ec2-instance.key_name
  subnet_id              = var.subnet_b
  vpc_security_group_ids = [aws_security_group.ec2_web_sg.id,aws_security_group.ec2_linux_sg.id]
  user_data = file("user-data.sh")

  root_block_device {
    volume_size           = "100"
    volume_type           = "gp3"
    delete_on_termination = true
  }

  
  tags = {
    Name        = "ec2-tutorial"
    "Automatic stop/start schedule" = "Enabled"
  }
  

  volume_tags = {
    Name        = "ec2-tutorial-volume"
    Createby    = var.create_by_name
  

  }

  # Keep this ami always
  lifecycle {
    ignore_changes = [ami,volume_tags,user_data]
  }

 }
