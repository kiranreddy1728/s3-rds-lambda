resource "aws_vpc_endpoint" "rewards_s3_endpoint" {
    vpc_id = "${var.vpc_id}"
    service_name = "com.amazonaws.${var.region}.s3"
    route_table_ids = ["${var.route_table_ids}"]
    policy = "${data.aws_iam_policy_document.rewards_s3_endpoint_policy.json}"
}

data "aws_iam_policy_document" "rewards_s3_endpoint_policy" {
    statement{
        actions = [
            "s3:List*",
            "s3:GetObject",
            "s3:PutObject",
        ]

        resources = [
            "arn:aws:s3:::rewards-${var.AWSaccount}-${var.region}-${var.Environment}-offers/",
            "arn:aws:s3:::rewards-${var.AWSaccount}-${var.region}-${var.Environment}-offers/*"

        ]
        effect = "Allow"

        principal = {
            type = "AWS"
            identifiers = ["*"]
        }
    }
}

