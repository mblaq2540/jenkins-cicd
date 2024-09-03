/**
 * Create by : Benja Kuneepong
 * Date : Thu, Aug  8, 2024 12:50:07 PM
 * Purpose : สร้าง subnet group สำหรับ mysql DB
 */
resource "aws_db_subnet_group" "mysq_db" {
  name       = "rds-mysql-subnet-group"
  subnet_ids = [var.subnet_b, var.subnet_a]
  

  tags = {
    Name = "rds-mysql-subnet-group"
  }
}

resource "aws_db_option_group" "mysq_db" {
  name                     = "rds-mysql-option-group"
  option_group_description = "mysql rds option group"
  engine_name              = "mysql"
  major_engine_version     = "8.0"

}

resource "aws_db_parameter_group" "mysq_db" {
  name        = "rds-mysql-option-group"
  description = "mysql rds parameter group"
  family      = "mysql8.0"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }

    parameter {
    name  = "time_zone"
    value = "Asia/Bangkok"
  }

}




resource "aws_db_instance" "mysq_db" {

  identifier           = "rds-mysql-database"
  engine               = var.rds_engine
  engine_version       = var.rds_engine_version
  instance_class       = var.rds_instance_type
  option_group_name    = aws_db_option_group.mysq_db.name
  parameter_group_name = aws_db_parameter_group.mysq_db.name
  ca_cert_identifier   = var.rds_ca_cert_identifier

  publicly_accessible = true
  multi_az               = var.rds_multi_az
  db_subnet_group_name   = aws_db_subnet_group.mysq_db.name
  vpc_security_group_ids = [aws_security_group.mysq_db_sg.id]

  # Make sure that database name is capitalized, otherwise RDS will try to recreate RDS instance every time
  db_name  = var.rds_database_name
  username = var.rds_admin
  password = var.rds_password
  port     = 3306

  storage_encrypted     = true
  storage_type          = var.rds_storage_type
  allocated_storage     = var.rds_allocated_storage
  max_allocated_storage = var.rds_max_allocated_storage

  backup_window               = "00:00-03:00"
  backup_retention_period     = 7
  copy_tags_to_snapshot       = true
  skip_final_snapshot         = true
  deletion_protection         = false
  auto_minor_version_upgrade  = false
  apply_immediately          = true

  # maintenance_window                    = "Mon:04:00-Mon:07:00"
  # enabled_cloudwatch_logs_exports       = ["error", "audit"]
  # performance_insights_enabled          = true
  # performance_insights_retention_period = 7
  
   /*
   lifecycle {
     ignore_changes = all
   }
  */
  
  tags = {
    Name   = "rds-mysql-database"
    "Automatic stop/start schedule" = "Enabled"
  }
}


