#bucket creation
resource "aws_s3_bucket" "rewards_offers" {
  bucket = "rewards-${var.AWSaccount}-${var.region}-${var.Environment}-offers"
  acl    = "private"
  #key   = "reawrdoffers/"
}

#bucket policy
resource "aws_s3_bucket_policy" "rewards_offers" {
  bucket = "${aws_s3_bucket.rewards_offers.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "MYBUCKETPOLICY",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Principal": {
            "AWS": "arn:aws:iam:${var.AWSaccount}:user/dtp-test-s3DataUploader"
      },
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::rewards-${var.AWSaccount}-${var.region}-${var.Environment}-offers/*"
    },
    {
      "Sid": "AllowS3Access",
      "Effect": "Allow",
      "Principal": {
            "AWS": "arn:aws:iam:${var.AWSaccount}:role/lambdasrdsrewards"
      },
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "arn:aws:s3:::rewards-${var.AWSaccount}-${var.region}-${var.Environment}-offers/",
        "arn:aws:s3:::rewards-${var.AWSaccount}-${var.region}-${var.Environment}-offers/*"
      ] 
    },
    {
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*"
      "Resource": [
        "arn:aws:s3:::rewards-${var.AWSaccount}-${var.region}-${var.Environment}-offers/",
        "arn:aws:s3:::rewards-${var.AWSaccount}-${var.region}-${var.Environment}-offers/*"
      ],
      "condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      }
    }

  ]
}
POLICY
}

/*
resource "aws_s3_bucket_policy" "rewards_offers" {
  bucket = "${aws_s3_bucket.rewards_offers.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "MYBUCKETPOLICY",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Principal":"*",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::ihub-accountid-rewards-offers/*"
    } 
  ]
}
POLICY
}*/