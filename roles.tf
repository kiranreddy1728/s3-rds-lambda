############ Role 1 ##########

# RDS Assume role 

resource "aws_iam_role" "ihub_RDSLoadFromS3" {
  name = "rewardsRDSLoadFromS3"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "rds.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Policy for s3 to load data to aurora
resource "aws_iam_policy" "ihub_RDSLoadFromS3_rds" {
    name        = "rewardsRDSLoadFromS3_rds"
    path        = "/"
    description = "Policy to load data from s3 into RDS(Aurora)"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
       {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:ListAllMyBuckets",
                "s3:HeadBucket",
                "s3:ListObjects"
            ],
            "Resource": "*"
        },
        {
          "Sid": "VisualEditior1",
          "Effect": "Allow",
          "Action": "s3:*",
          "Resource": [
              "arn:aws:s3:::rewards-${var.AWSaccount}-${var.region}-${var.Environment}-offers/",
              "arn:aws:s3:::rewards-${var.AWSaccount}-${var.region}-${var.Environment}-offers/*"
          ] 
        }
    ]
}
POLICY
}

#Policy attachment for s3 & RDS

resource "aws_iam_role_policy_attachment" "rdsloadfroms3_role_attachment_s3_rds" {
    role = "${aws_iam_role.ihub_RDSLoadFromS3.name}"
    policy_arn = "${aws_iam_policy.ihub_RDSLoadFromS3_rds.arn}"  
}

##############   Role 2 ##########################

# Lambda Assume role 

resource "aws_iam_role" "lambda_apigateway" {
  name = "lambdaapigateway"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "sid": ""
      
    }
  ]
}
POLICY
}

### Policy for S3 to load data to aurora ######

resource "aws_iam_policy" "rewardsapiLambdaconnect" {
    name        = "offersRDSLambdaconnectProd"
    path        = "/"
    description = "Lambda S3 Connection Policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Sid": "VisualEditior2",
          "Effect": "Allow",
          "Action": "rds-db:connect",
          "Resource": "arn:aws:rds-db:${var.region}:${var.AWSaccount}:dbuser:${aws_rds_cluster.rds_cluster.cluster_resource_id}/lambda" 
        },
       {
           "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "ec2:CreateNetworkInterface",
                "ec2:DescribeNetworkInterface",
                "ec2:DeleteNetworkInterface"
            ],
            "Resource": "*"
        },
        {
            "Action": [
                "logs:*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}

#Policy attachment for s3 & RDS

resource "aws_iam_role_policy_attachment" "rdsloadfroms3_role_attachment_apilambda" {
    role = "${aws_iam_role.lambda_apigateway.name}"
    policy_arn = "${aws_iam_policy.rewardsapiLambdaconnect.arn}"  
}

##############   Role 3 ##########################

# Lambda Assume role 

resource "aws_iam_role" "lambda_rds" {
  name = "lambdardsrewards"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "sid": ""  
    }
  ]
}
POLICY
}


### Policy for S3 to load data to aurora ######



resource "aws_iam_policy" "rewardsRDSLambdaconnect" {
    name        = "offersRDSLambdaconnectProd"
    path        = "/"
    description = "Lambda S3 Connection Policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Sid": "VisualEditior2",
          "Effect": "Allow",
          "Action": "rds-db:connect",
          "Resource": "arn:aws:rds-db:${var.region}:${var.AWSaccount}:dbuser:${aws_rds_cluster.rds_cluster.cluster_resource_id}/lambda" 
        },
       {
           "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "ec2:CreateNetworkInterface",
                "ec2:DescribeNetworkInterface",
                "ec2:DeleteNetworkInterface"
            ],
            "Resource": "*"
        },
        {
            "Action": [
                "logs:*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetEncryptionConfiguration",
                "s3:GetBucketNotification"
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::rewards-${var.AWSaccount}-${var.region}-${var.Environment}-offers/",
                "arn:aws:s3:::rewards-${var.AWSaccount}-${var.region}-${var.Environment}-offers/*"
            ]
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "s3:GetAccountPublicAccessBlock",
                "s3:ListAllMyBuckets",
                "s3:HeadBucket",
                "cloudfront:CreateInvalidation"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

#Policy attachment for lambda & RDS

resource "aws_iam_role_policy_attachment" "rdsloadfroms3_role_attachment_RDSlambda" {
    role = "${aws_iam_role.lambda_rds.name}"
    policy_arn = "${aws_iam_policy.rewardsRDSLambdaconnect.arn}"  
}