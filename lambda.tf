resource "aws_lambda_function" "apigateway_lambda" {
  filename         = "${path.module}/OffersData.zip"
  function_name    = "OffersData"
  role             = "${aws_iam_role.lambda_apigateway.arn}"
  handler          = "OffersData.handler"
  runtime          = "python2.7"
  source_code_hash = "${base64sha256(file("${path.module}/OffersData.zip"))}"
  memory_size      = 256
  timeout          = 120   

     vpc_config {
       subnet_ids = ["${var.subnet_ids}"] //["subnet-9e76a8f9", "subnet-2f75ab48"]
       security_group_ids = ["${aws_security_group.lambda-sg.id}"]
   }
     environment {
    variables = {
      //AWS_SQS_URL = "${aws_sqs_queue.some_queue.id}"
      //ASG_NAME    = "${aws_autoscaling_group.some_asg.name}"
      //http_proxy = "http://proxy.svpc.pre-prod.eu-west-1.aws.internal:3128"
      //https_proxy = "http://proxy.svpc.pre-prod.eu-west-1.aws.internal:3128"
      //no_proxy = "169.254.169.254, .hsbc"
      host = "${aws_rds_cluster.rds_cluster.endpoint}"
    }
  }
}

# Lambda api integration
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.apigateway_lambda.arn}"
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.region}:${var.AWSaccount}:${aws_api_gateway_rest_api.rewardsapi.id}/*/${aws_api_gateway_method.method.http_method} ${aws_api_gateway_resource.id.path}"
}



#############Load Data s3 to Aurora ###########
resource "aws_lambda_function" "RewardsLoadDataS3Aurora" {
  filename         = "${path.module}/LoadDataS3Aurora.zip"
  function_name    = "RewardsLoadDataS3Aurora"
  role             = "${aws_iam_role.lambda_rds.arn}"
  handler          = "LoadDataS3Aurora.handler"
  runtime          = "python2.7"
  source_code_hash = "${base64sha256(file("${path.module}/LoadDataS3Aurora.zip"))}"
  memory_size      = 1024
  timeout          = 300  

     vpc_config {
       subnet_ids = ["${var.subnet_ids}"] //["subnet-9e76a8f9", "subnet-2f75ab48"]
       security_group_ids = ["${aws_security_group.lambda-sg.id}"]
   }
     environment {
    variables = {
      //AWS_SQS_URL = "${aws_sqs_queue.some_queue.id}"
      //ASG_NAME    = "${aws_autoscaling_group.some_asg.name}"
      //http_proxy = "http://proxy.svpc.pre-prod.eu-west-1.aws.internal:3128"
      //https_proxy = "http://proxy.svpc.pre-prod.eu-west-1.aws.internal:3128"
      //no_proxy = "169.254.169.254, .hsbc"
      host = "${aws_rds_cluster.rds_cluster.endpoint}"
      CDNDistributionID = "${aws_cloudfront_distribution.offers_distribution.id}"
    }
  }
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.RewardsLoadDataS3Aurora.arn}"
  principal     = "s3.amazonaws.com"
  source_arn = "${aws_s3_bucket.rewards_offers.arn}"
}


resource "aws_s3_bucket_notification" "ihub_load_data_s3_aurora" {
    bucket = "rewards-${var.AWSaccount}-${var.region}-${var.Environment}-offers"

    lambda_function {
        lambda_function_arn = "${aws_lambda_function.RewardsLoadDataS3Aurora.arn}"
        events              = ["s3:objectCreated:*"]
        filter_prefix       = "offersdata/"  
        filter_suffix       = ".csv"
    }  
}

################### Initial setup ##########

resource "aws_lambda_function" "InitialSetupRDS" {
  filename         = "${path.module}/InitialSetupRDS.zip"
  function_name    = "InitialSetupRDS"
  role             = "${aws_iam_role.lambda_rds.arn}"
  handler          = "LoadDataS3Aurora.handler"
  runtime          = "python2.7"
  source_code_hash = "${base64sha256(file("${path.module}/LoadDataS3Aurora.zip"))}"
  memory_size      = 256
  timeout          = 120

     vpc_config {
       subnet_ids = ["${var.subnet_ids}"] //["subnet-9e76a8f9", "subnet-2f75ab48"]
       security_group_ids = ["${aws_security_group.lambda-sg.id}"]
   }
     environment {
    variables = {
      //AWS_SQS_URL = "${aws_sqs_queue.some_queue.id}"
      //ASG_NAME    = "${aws_autoscaling_group.some_asg.name}"
      //http_proxy = "http://proxy.svpc.pre-prod.eu-west-1.aws.internal:3128"
      //https_proxy = "http://proxy.svpc.pre-prod.eu-west-1.aws.internal:3128"
      //no_proxy = "169.254.169.254, .hsbc"
      host = "${aws_rds_cluster.rds_cluster.endpoint}"
      password = "${data.aws_ssm_parameter.aurora_master_passwd_ssm.value}"
    }
  }
}
