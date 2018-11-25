

# RDS Assume role 

resource "aws_iam_role" "rewards_RDSLoadFromS3" {
  name = "RDSLoadFromS3Offers"

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

# create IAM role for monitoring- RDS
resource "aws_iam_role" "enhanced_monitoring" {
  name               = "rds-cluster-monitoring-1"
  assume_role_policy = "${data.aws_iam_policy_document.enhanced_monitoring.json}"
}

# Allow rds to assume this role for monitoring -RDS
data "aws_iam_policy_document" "enhanced_monitoring" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

# Attach Amazon's managed policy for RDS enhanced monitoring - RDS
resource "aws_iam_role_policy_attachment" "enhanced_monitoring" {
  role       = "${aws_iam_role.enhanced_monitoring.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}


#RDS
resource "aws_iam_policy" "rewards_RDSLoadFromS3" {
    name = "RDSLoadFromS3Rewards"
    path = "/"

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
      "Sid": "VisualEditor1",
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": [    
            "arn:aws:s3:::ihub-accountid-rewards-offers/*",
            "arn:aws:s3:::ihub-accountid-rewards-offers"
      ]
    } 
  ]
}
POLICY
}

#RDS policy attachment

resource "aws_iam_role_policy_attachment" "rdsloadfroms3_role_attachment" {
    role = "${aws_iam_role.rewards_RDSLoadFromS3.name}"
    policy_arn = "${aws_iam_policy.rewards_RDSLoadFromS3.arn}"  
}



