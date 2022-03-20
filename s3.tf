
/************* S3 Bucket:Strapi ******************/
resource "aws_s3_bucket" "strapi" {
  bucket = "${var.project.name}-${terraform.workspace}-strapi"
  tags   = var.default_tags
}

resource "aws_s3_bucket_acl" "strapi" {
  bucket = aws_s3_bucket.strapi.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "strapi" {
  bucket = aws_s3_bucket.strapi.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.s3.ksm_key
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_cloudfront_origin_access_identity" "strapi" {
  comment = "${var.project.name}-${terraform.workspace}-strapi"
}

resource "aws_s3_bucket_public_access_block" "strapi" {
  bucket                  = aws_s3_bucket.strapi.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "strapi" {
  bucket = aws_s3_bucket.strapi.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "${var.project.name}-${terraform.workspace}",
    "Statement" : [
      {
        "Sid" : " Grant a CloudFront Origin Identity access to support private content",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "${aws_cloudfront_origin_access_identity.strapi.iam_arn}"
        },
        "Action" : "s3:GetObject",
        "Resource" : "${aws_s3_bucket.strapi.arn}/*"
      }
    ]
  })
}

/************* S3 Bucket:nextjs ******************/
resource "aws_cloudfront_origin_access_identity" "nextjs" {
  comment = "${var.project.name}-${terraform.workspace}-nextjs"
}

resource "aws_s3_bucket" "nextjs" {
  bucket = "${var.project.name}-${terraform.workspace}-nextjs"
  tags   = var.default_tags
}

resource "aws_s3_bucket_acl" "nextjs" {
  bucket = aws_s3_bucket.nextjs.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "nextjs" {
  bucket = aws_s3_bucket.nextjs.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.s3.ksm_key
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "nextjs" {
  bucket                  = aws_s3_bucket.nextjs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "nextjs" {
  bucket = aws_s3_bucket.nextjs.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "${var.project.name}-${terraform.workspace}",
    "Statement" : [
      {
        "Sid" : " Grant a CloudFront Origin Identity access to support private content",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "${aws_cloudfront_origin_access_identity.nextjs.iam_arn}"
        },
        "Action" : "s3:GetObject",
        "Resource" : "${aws_s3_bucket.nextjs.arn}/*"
      }
    ]
  })
}


/************* S3 Bucket:logging ******************/
resource "aws_s3_bucket" "logging" {
  bucket = "${var.project.name}-${terraform.workspace}-logging"
  tags   = var.default_tags
}

resource "aws_s3_bucket_acl" "logging" {
  bucket = aws_s3_bucket.logging.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logging" {
  bucket = aws_s3_bucket.logging.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.s3.ksm_key
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "logging" {
  bucket                  = aws_s3_bucket.logging.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
