/**
 * Create by : Benja kuneepong
 * Date : Thu, Aug 15, 2024  9:05:01 AM
 * Purpose : สร้าง crontab สำหรับ stop DB
 */
resource "aws_cloudwatch_event_rule" "stop_database_2000" {
  name                = "stop-database-lamda-event"
  description         = "-"
  schedule_expression = "cron(30 03 ? * MON-SUN *)" // UTC
}
resource "aws_cloudwatch_event_target" "stop_database_2000" {
  rule      = aws_cloudwatch_event_rule.stop_database_2000.name
  target_id = "stop_database_2000"
  arn       = aws_lambda_function.stop_database.arn
}

/**
 * Create by : Benja kuneepong
 * Date : Thu, Aug 15, 2024  9:05:01 AM
 * Purpose : สร้าง crontab สำหรับ start DB
 */
resource "aws_cloudwatch_event_rule" "start_database_0800" {
  name                = "start-database-lamda-event"
  description         = "-"
  schedule_expression = "cron(00 04 ? * MON-SUN *)" // UTC
}
resource "aws_cloudwatch_event_target" "start_database_0800" {
  rule      = aws_cloudwatch_event_rule.start_database_0800.name
  target_id = "start_database_0800"
  arn       = aws_lambda_function.start_database.arn
}


/**
 * Create by : Benja kuneepong
 * Date : Thu, Aug 15, 2024  9:05:01 AM
 * Purpose : สร้าง crontab สำหรับ stop EC2
 */
resource "aws_cloudwatch_event_rule" "stop_ec2_2000" {
  name                = "stop-ec2-lamda-event"
  description         = "-"
  schedule_expression = "cron(30 03 ? * MON-SUN *)" // +7UTC
  #"cron(30 03 ? * MON-SUN *)" 10:30am
  #"cron(30 01 ? * MON-SUN *)" 8:30am
  #"cron(30 23 ? * SUN-THU *)" 6:30am
}
resource "aws_cloudwatch_event_target" "stop_ec2_2000" {
  rule      = aws_cloudwatch_event_rule.stop_ec2_2000.name
  target_id = "stop_ec2_2000"
  arn       = aws_lambda_function.stop_ec2.arn
}

/**
 * Create by : Benja kuneepong
 * Date : Thu, Aug 15, 2024  9:05:01 AM
 * Purpose : สร้าง crontab สำหรับ start EC2
 */
resource "aws_cloudwatch_event_rule" "start_ec2_0800" {
  name                = "start-ec2-lamda-event"
  description         = "-"
  schedule_expression = "cron(00 04 ? * MON-SUN *)" // +7UTC
}
resource "aws_cloudwatch_event_target" "start_ec2_0800" {
  rule      = aws_cloudwatch_event_rule.start_ec2_0800.name
  target_id = "start_ec2_0800"
  arn       = aws_lambda_function.start_ec2.arn
}






