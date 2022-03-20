/************* Lambda: backend-ecs ******************/
resource "aws_iam_role" "backend-ecs" {
  name = "${var.project.name}-${terraform.workspace}-backend-ecs-lambda-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : [
            "lambda.amazonaws.com",
            "edgelambda.amazonaws.com"
          ]
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "Custom-Lambda-Basic-Execution-Policy" {
  policy_arn = "arn:aws:iam::${var.aws.account_id}:policy/Custom-Lambda-Basic-Execution-Policy"
  role       = aws_iam_role.backend-ecs.id
}

resource "aws_iam_role_policy_attachment" "Lambda-VPC-integration-policy" {
  policy_arn = "arn:aws:iam::${var.aws.account_id}:policy/Lambda-VPC-integration-policy"
  role       = aws_iam_role.backend-ecs.id
}

resource "aws_security_group" "api-gateway-proxy-SG" {
  name        = "${var.project.name}-${terraform.workspace}-lambda-proxy-sg"
  description = "${var.project.name}-${terraform.workspace}-lambda-proxy-sg"
  vpc_id      = var.aws.vpc_id
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.microservices.id]
  }
  tags = var.default_tags
}


resource "aws_lambda_function" "backend-ecs" {
  filename      = "api-gateway-proxy-handler.zip"
  function_name = "${var.project.name}-${terraform.workspace}-backend-ecs"
  role          = aws_iam_role.backend-ecs.arn
  handler       = "index.handler"
  timeout       = "20"

  source_code_hash = filebase64sha256("api-gateway-proxy-handler.zip")
  runtime          = "nodejs12.x"

  environment {
    variables = {
      TARGET_URL = "${var.project.name}-${terraform.workspace}-lb.maxlifeinsurance.com"
    }
  }

  vpc_config {
    subnet_ids         = [var.lambda.vpc_config_subnet_id_1, var.lambda.vpc_config_subnet_id_2]
    security_group_ids = [aws_security_group.api-gateway-proxy-SG.id]
  }
  tags = var.default_tags
}



/************* Lambda: CDN-request ******************/
resource "aws_iam_role" "cdn-request-edgelambda-role" {
  name = "${var.project.name}-${terraform.workspace}-cdn-request-edgelambda-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : [
            "lambda.amazonaws.com",
            "edgelambda.amazonaws.com"
          ]
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "cdn-AWS-lambda-Edge-Execution-Role" {
  policy_arn = "arn:aws:iam::${var.aws.account_id}:policy/Custom-Lambda-Basic-Execution-Policy"
  role       = aws_iam_role.cdn-request-edgelambda-role.id
}

resource "aws_iam_role_policy_attachment" "cdn-execution-policy" {
  policy_arn = "arn:aws:iam::${var.aws.account_id}:policy/Lambda-VPC-integration-policy"
  role       = aws_iam_role.cdn-request-edgelambda-role.id
}

resource "aws_lambda_function" "cdn-request" {
  filename         = "cdn-request-lambda.zip"
  function_name    = "${var.project.name}-${terraform.workspace}-cdn-request-edgelambda"
  role             = aws_iam_role.cdn-request-edgelambda-role.arn
  handler          = "index.handler"
  timeout          = "3"
  source_code_hash = filebase64sha256("cdn-request-lambda.zip")
  runtime          = "nodejs12.x"
  provider         = aws.east
  tags             = var.default_tags
}


/************* Lambda: CDN-response ******************/
resource "aws_iam_role" "cdn-response-edgelambda-role" {
  name = "${var.project.name}-${terraform.workspace}-cdn-response-edgelambda-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : [
            "lambda.amazonaws.com",
            "edgelambda.amazonaws.com"
          ]
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cdn-response-AWS-lambda-Edge-Execution-Role" {
  policy_arn = "arn:aws:iam::${var.aws.account_id}:policy/Custom-Lambda-Basic-Execution-Policy"
  role       = aws_iam_role.cdn-response-edgelambda-role.id
}

resource "aws_iam_role_policy_attachment" "cdn-response-execution-policy" {
  policy_arn = "arn:aws:iam::${var.aws.account_id}:policy/Lambda-VPC-integration-policy"
  role       = aws_iam_role.cdn-response-edgelambda-role.id
}

resource "aws_lambda_function" "cdn-response" {
  filename         = "cdn-response-lambda.zip"
  function_name    = "${var.project.name}-${terraform.workspace}-cdn-response-edgelambda"
  role             = aws_iam_role.cdn-response-edgelambda-role.arn
  handler          = "index.handler"
  timeout          = "3"
  source_code_hash = filebase64sha256("cdn-response-lambda.zip")
  runtime          = "nodejs12.x"
  provider         = aws.east
  tags             = var.default_tags
}


/************* Lambda: backend-s2s-ecs ******************/
resource "aws_iam_role" "backend-s2s-ecs" {
  name = "${var.project.name}-${terraform.workspace}-backend-s2s-ecs-lambda-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : [
            "lambda.amazonaws.com",
            "edgelambda.amazonaws.com"
          ]
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "Custom-Lambda-Basic-Execution-Policy-s2s" {
  policy_arn = "arn:aws:iam::${var.aws.account_id}:policy/Custom-Lambda-Basic-Execution-Policy"
  role       = aws_iam_role.backend-s2s-ecs.id
}

resource "aws_iam_role_policy_attachment" "Lambda-VPC-integration-policy-s2s" {
  policy_arn = "arn:aws:iam::${var.aws.account_id}:policy/Lambda-VPC-integration-policy"
  role       = aws_iam_role.backend-s2s-ecs.id
}

resource "aws_security_group" "api-gateway-proxy-SG-s2s" {
  name        = "${var.project.name}-${terraform.workspace}-lambda-proxy-sg-s2s"
  description = "${var.project.name}-${terraform.workspace}-lambda-proxy-sg-s2s"
  vpc_id      = var.aws.vpc_id
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.microservices.id]
  }
  tags = var.default_tags
}


resource "aws_lambda_function" "backend-s2s-ecs" {
  filename      = "api-gateway-proxy-handler.zip"
  function_name = "${var.project.name}-${terraform.workspace}-backend-s2s-ecs"
  role          = aws_iam_role.backend-s2s-ecs.arn
  handler       = "index.handler"
  timeout       = "20"

  source_code_hash = filebase64sha256("api-gateway-proxy-handler.zip")
  runtime          = "nodejs12.x"

  environment {
    variables = {
      TARGET_URL = "${var.project.name}-${terraform.workspace}-lb.maxlifeinsurance.com"
    }
  }

  vpc_config {
    subnet_ids         = [var.lambda.vpc_config_subnet_id_1, var.lambda.vpc_config_subnet_id_2]
    security_group_ids = [aws_security_group.api-gateway-proxy-SG-s2s.id]
  }
  tags = var.default_tags
}
