#bucket creation
resource "aws_s3_bucket" "rewards_offers" {
  bucket = "ihub-accountid-rewards-offers"
  acl    = "private"
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
      "Principal":"*",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::ihub-accountid-rewards-offers/*"
    } 
  ]
}
POLICY
}