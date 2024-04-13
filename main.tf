# First step {Create s3 bucket}
resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucket
}
# second step{specify the ownship control}
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

/*in third step all aws_s3_bucket_public_access_block default value is true that indicate this are all private 
to make it public we make it false*/

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}

resource "aws_s3_object" "index" {
  key        = "index.html"
  bucket     = aws_s3_bucket.mybucket.id
  source     = "index.html"
  acl         = "public-read"
  # kms_key_id = aws_kms_key.examplekms.arn
  content_type = "text/html"
}

resource "aws_s3_object" "profile" {

  bucket     = aws_s3_bucket.mybucket.id
  key = "img/"
  source = "C:/Users/user/Desktop/mys3staticwebsite/s3webhosting/img"
  acl         = "public-read"
}


resource "aws_s3_object" "style" {
  bucket     = aws_s3_bucket.mybucket.id
  key =    "style.css"
  source =  "C:/Users/user/Desktop/mys3staticwebsite/s3webhosting/style.css"
  acl       = "public-read"
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.mybucket.id
  index_document {
    suffix = "index.html"
  }
  depends_on = [ aws_s3_bucket_acl.example ]
}