/**
 * Create by : Benja kuneepong
 * Date : Thu, Aug 15, 2024  9:05:01 AM
 * Purpose : สร้าง lambda สำหรับ stop/start database
 */
provider "archive" {}
data "archive_file" "stop_database" {
  type        = "zip"
  source_file = "./code_lambda/stop_database/main.py"
  output_path = "./code_lambda/stop_database/main.zip"
}

resource "aws_lambda_function" "stop_database" {
  function_name    = "auto-stop-db-lamda-test"
  filename         = data.archive_file.stop_database.output_path
  source_code_hash = data.archive_file.stop_database.output_base64sha256
  role             = aws_iam_role.database_stopstart_lambda.arn
  handler          = "main.lambda_handler"
  runtime          = "python3.10"
  timeout          = 30

  environment {
    variables = {
      schedule_key : "Automatic stop/start schedule",
      schedule_value : "Enabled",
      environment_key : "Environment",
      environment_value : "dev",
    }
  }
}

resource "aws_lambda_permission" "stop_database_allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.stop_database.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.stop_database_2000.arn
}



data "archive_file" "start_database" {
  type        = "zip"
  source_file = "./code_lambda/start_database/main.py"
  output_path = "./code_lambda/start_database/main.zip"
}

resource "aws_lambda_function" "start_database" {
  function_name    = "auto-start-db-lamda-test"
  filename         = data.archive_file.start_database.output_path
  source_code_hash = data.archive_file.start_database.output_base64sha256
  role             = aws_iam_role.database_stopstart_lambda.arn
  handler          = "main.lambda_handler"
  runtime          = "python3.10"
  timeout          = 30

  environment {
    variables = {
      schedule_key : "Automatic stop/start schedule",
      schedule_value : "Enabled",
      environment_key : "Environment",
      environment_value : "dev",
    }
  }
}

resource "aws_lambda_permission" "start_database_allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.start_database.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.start_database_0800.arn
}



/**
 * Create by : Benja kuneepong
 * Date : Tue, Jun 11, 2024  9:02:08 AM
 * Purpose : สร้าง lamda สำหรับ stop ec2
 */
data "archive_file" "stop_ec2" {
  type        = "zip"
  source_file = "./code_lambda/stop_ec2/main.py"
  output_path = "./code_lambda/stop_ec2/main.zip"
}

resource "aws_lambda_function" "stop_ec2" {
  function_name    = "auto-stop-ec2-lamda-test"
  filename         = data.archive_file.stop_ec2.output_path
  source_code_hash = data.archive_file.stop_ec2.output_base64sha256
  role             = aws_iam_role.ec2_stopstart_lambda.arn
  handler          = "main.lambda_handler"
  runtime          = "python3.10"
  timeout          = 30

  environment {
    variables = {
      schedule_key : "Automatic stop/start schedule",
      schedule_value : "Enabled",
      environment_key : "Environment",
      environment_value : "dev",
    }
  }
}

resource "aws_lambda_permission" "stop_ec2_allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.stop_ec2.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.stop_ec2_2000.arn
}

/*******************************************************************************************************************************/

/**
 * Create by : Benja kuneepong
 * Date : Tue, Jun 11, 2024  9:02:08 AM
 * Purpose : สร้าง lamda สำหรับ start ec2
 */
data "archive_file" "start_ec2" {
  type        = "zip"
  source_file = "./code_lambda/start_ec2/main.py"
  output_path = "./code_lambda/start_ec2/main.zip"
}

resource "aws_lambda_function" "start_ec2" {
  function_name    = "auto-start-ec2-lamda-test"
  filename         = data.archive_file.start_ec2.output_path
  source_code_hash = data.archive_file.start_ec2.output_base64sha256
  role             = aws_iam_role.ec2_stopstart_lambda.arn
  handler          = "main.lambda_handler"
  runtime          = "python3.10"
  timeout          = 30

  environment {
    variables = {
      schedule_key : "Automatic stop/start schedule",
      schedule_value : "Enabled",
      environment_key : "Environment",
      environment_value : "dev",
    }
  }
}

resource "aws_lambda_permission" "start_ec2_allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.start_ec2.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.start_ec2_0800.arn
}