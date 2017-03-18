provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "minecraft" {
  name = "minecraft_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "s3_saves" {
  name = "s3_saves"
  path = "/"
  description = "Sync access for the worlds s3 bucket"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListAllMyBuckets"
      ],
      "Resource": [
        "arn:aws:s3:::*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
          "s3:ListBucket",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:GetObject"
      ],
      "Resource": [
          "arn:aws:s3:::saves-alex",
          "arn:aws:s3:::saves-alex/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_policy" "ecs" {
  name = "minecraft_ecs_access"
  path = "/"
  description = "Minecraft ECS service access"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:RegisterContainerInstance",
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Submit*",
        "ecs:Poll",
        "ecs:StartTask",
        "ecs:StartTelemetrySession",
        "ecs:CreateCluster"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_policy" "ecs_cloudwatch" {
  name = "ecs_cloudwatch"
  path = "/"
  description = "CloudWatch logging for ECS"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams"
            ],
            "Resource": [
                "arn:aws:logs:*:*:*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "ecs" {
  name = "ecs_attachment"
  roles = ["${aws_iam_role.minecraft.id}"]
  policy_arn = "${aws_iam_policy.ecs.arn}"
}

resource "aws_iam_policy_attachment" "ecs_cloudwatch" {
  name = "ecs_cloudwatch_attachment"
  roles = ["${aws_iam_role.minecraft.id}"]
  policy_arn = "${aws_iam_policy.ecs_cloudwatch.arn}"
}

resource "aws_iam_policy_attachment" "s3_sync" {
  name = "s3_sync_attachment"
  roles = ["${aws_iam_role.minecraft.id}"]
  policy_arn = "${aws_iam_policy.s3_saves.arn}"
}

resource "aws_iam_instance_profile" "minecraft" {
  name = "minecraft"
  roles = ["${aws_iam_role.minecraft.id}"]
}

output "iam_role_arn" {
  value = "aws_iam_role.minecraft.arn"
}

output "instance_profile" {
  value = "${aws_iam_instance_profile.minecraft.id}"
}