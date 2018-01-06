provider "aws" {
	region = "us-east-1"
}

resource "aws_s3_bucket" "web_content_bucket" {
	bucket = "alexkokkinos-web"
	acl = "private"
	versioning {
		enabled = true
	}
	lifecycle_rule {
		id = "old_version_expiration"
		enabled = true
		prefix = "/"
		noncurrent_version_expiration {
			days = 90
		}
	}
	tags {
		Name = "Alex Kokkinos Web Bucket"
	}
}

resource "aws_s3_bucket_policy" "s3_policy" {
	bucket = "${aws_s3_bucket.web_content_bucket.id}"
	policy = "${aws_iam_policy.public_bucket_policy.json}"
}

resource "aws_iam_policy" "public_bucket_policy" {
	name = "public_web_s3_policy"
	path = "/"
	description "Policy to allow public website S3 bucket content download"
	policy = << EOF
{
  "Version":"2012-10-17",
  "Statement":[{
	"Sid":"PublicReadGetObject",
        "Effect":"Allow",
	  "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::alexkokkinos.com/*"
      ]
    }
  ]
}
EOF
}
