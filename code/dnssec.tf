provider "aws" {
  region = "eu-central-1"
}

data "aws_caller_identity" "current" {}

resource "aws_kms_key" "dnssec_key" {
  customer_master_key_spec = "ECC_NIST_P256"
  deletion_window_in_days  = 7
  key_usage                = "SIGN_VERIFY"
  policy = jsonencode({
    Statement = [
      {
        Action = [
          "kms:DescribeKey",
          "kms:GetPublicKey",
          "kms:Sign",
        ],
        Effect = "Allow",
        Principal = {
          Service = "dnssec-route53.amazonaws.com"
        },
        Sid      = "Allow Route 53 DNSSEC Service",
        Resource = "*",
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          },
          ArnLike = {
            "aws:SourceArn" = "arn:aws:route53:::hostedzone/*"
          }
        }
      },
      {
        Action = "kms:CreateGrant",
        Effect = "Allow",
        Principal = {
          Service = "dnssec-route53.amazonaws.com"
        },
        Sid      = "Allow Route 53 DNSSEC Service to CreateGrant",
        Resource = "*",
        Condition = {
          Bool = {
            "kms:GrantIsForAWSResource" = "true"
          }
        }
      },
      {
        Action = "kms:*",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Resource = "*",
        Sid      = "Enable IAM User Permissions"
      },
    ],
    Version = "2012-10-17"
  })
}

resource "aws_route53_zone" "sda_se_io_zone" {
  name = "sda-se.io"
}

resource "aws_route53_zone" "projekt1_public_zone" {
  name = "projekt1.sda-se.io"
}

resource "aws_route53_zone" "dev_projekt1_public_zone" {
  name = "dev.projekt1.sda-se.io"
}

resource "aws_route53_record" "sda_se_io_to_projekt1" {
  zone_id = aws_route53_zone.sda_se_io_zone.zone_id
  name    = "projekt1"
  type    = "NS"
  ttl     = 300
  records = aws_route53_zone.projekt1_public_zone.name_servers
}

resource "aws_route53_record" "projekt1_to_dev_projekt1_public" {
  zone_id = aws_route53_zone.projekt1_public_zone.zone_id
  name    = "dev"
  type    = "NS"
  ttl     = 300
  records = aws_route53_zone.dev_projekt1_public_zone.name_servers
}

resource "aws_route53_key_signing_key" "dev_projekt1_public_zone" {
  hosted_zone_id = aws_route53_zone.dev_projekt1_public_zone.id
  key_management_service_arn = aws_kms_key.dnssec_key.arn
  name                       = "dev"
}

resource "aws_route53_hosted_zone_dnssec" "dev_projekt1_public_zone" {
  hosted_zone_id = aws_route53_zone.dev_projekt1_public_zone.id
}

resource "aws_route53_key_signing_key" "projekt1_public_zone" {
  hosted_zone_id = aws_route53_zone.projekt1_public_zone.id
  key_management_service_arn = aws_kms_key.dnssec_key.arn
  name                       = "projekt1"
}

resource "aws_route53_hosted_zone_dnssec" "projekt1_public_zone" {
  hosted_zone_id = aws_route53_zone.projekt1_public_zone.id
}

resource "aws_route53_record" "projekt1_to_dev_projekt1_public" {
  zone_id = aws_route53_zone.projekt1_public_zone.zone_id
  name    = "dev"
  type    = "DS"
  ttl     = 300
  records = [
    aws_route53_key_signing_key.dev_projekt1_public_zone.ds_record,
  ]
}

resource "aws_route53_key_signing_key" "projekt1_public_zone" {
  hosted_zone_id     = aws_route53_zone.sda_se_io_zone.id
  key_management_service_arn = aws_kms_key.dnssec_key.arn
  name                       = "sda-se"
}

resource "aws_route53_hosted_zone_dnssec" "projekt1_public_zone" {
  hosted_zone_id = aws_route53_zone.sda_se_io_zone.id
}

resource "aws_route53_record" "projekt1_to_dev_projekt1_public" {
  zone_id = aws_route53_zone.sda_se_io_zone.zone_id
  name    = "projekt1"
  type    = "DS"
  ttl     = 300
  records = [
    aws_route53_key_signing_key.projekt1_public_zone.ds_record,
  ]
}
