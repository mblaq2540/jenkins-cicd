/**
 * Create by : Benja kuneepong
 * Date : Thu, Aug 15, 2024  1:17:54 PM
 * Purpose : สร้าง policy สำหรับ stop/start EC2
 */
resource "aws_iam_policy" "ec2_stopstart_policy" {
  name        = "ec2_stopstart_policy_test"
  path        = "/"
  description = "Custom EC2 stop/start policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Start*",
          "ec2:Stop*",
          "ec2:Describe*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Effect : "Allow",
        Action : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource : "arn:aws:logs:*:*:*"
      }
    ]
  })
}

data "aws_iam_policy_document" "ec2_stopstart_policy" {
  statement {
    sid    = ""
    effect = "Allow"
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ec2_stopstart_lambda" {
  name               = "ec2_stopstart_lambda_test"
  assume_role_policy = data.aws_iam_policy_document.ec2_stopstart_policy.json
}

resource "aws_iam_role_policy_attachment" "ec2-stopstart-policy-attach" {
  role       = aws_iam_role.ec2_stopstart_lambda.name
  policy_arn = aws_iam_policy.ec2_stopstart_policy.arn
}


/***********************************************************************************************************/
/**
 * Create by : Benja kuneepong
 * Date : Thu, Aug 15, 2024  1:17:54 PM
 * Purpose : สร้าง policy สำหรับ stop/start RDS
 */
resource "aws_iam_policy" "database_stopstart_policy" {
  name        = "database_stopstart_policy_test"
  path        = "/"
  description = "Custom RDS stop/start policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "rds:DescribeDBClusterParameters",
          "rds:StartDBCluster",
          "rds:StopDBCluster",
          "rds:DescribeDBEngineVersions",
          "rds:DescribeGlobalClusters",
          "rds:DescribePendingMaintenanceActions",
          "rds:DescribeDBLogFiles",
          "rds:StopDBInstance",
          "rds:StartDBInstance",
          "rds:DescribeReservedDBInstancesOfferings",
          "rds:DescribeReservedDBInstances",
          "rds:ListTagsForResource",
          "rds:DescribeValidDBInstanceModifications",
          "rds:DescribeDBInstances",
          "rds:DescribeSourceRegions",
          "rds:DescribeDBClusterEndpoints",
          "rds:DescribeDBClusters",
          "rds:DescribeDBClusterParameterGroups",
          "rds:DescribeOptionGroups"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Effect : "Allow",
        Action : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource : "arn:aws:logs:*:*:*"
      }
    ]
  })
}

data "aws_iam_policy_document" "database_stopstart_policy" {
  statement {
    sid    = ""
    effect = "Allow"
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "database_stopstart_lambda" {
  name               = "database_stopstart_lambda_test"
  assume_role_policy = data.aws_iam_policy_document.database_stopstart_policy.json
}

resource "aws_iam_role_policy_attachment" "database-stopstart-policy-attach" {
  role       = aws_iam_role.database_stopstart_lambda.name
  policy_arn = aws_iam_policy.database_stopstart_policy.arn
}

