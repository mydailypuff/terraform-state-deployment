provider "aws" {
  region  = local.region
}


terraform {
  required_providers {
    aws = {
      version = "~> 5.0"
    }
  }
}


resource "aws_s3_bucket" "tf-state-bucket" {
  bucket = local.account_id #State-bucket name with accountid always keeps state bucket name unique

  versioning {
    enabled= true
  }
  
  server_side_encryption_configuration {
    rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
  }

  tags = {
    Name        = "tf-state"
    Environment = local.env
  }
}

resource "aws_s3_bucket_object" "tf-state-guard" {
  bucket = aws_s3_bucket.tf-state-bucket.id
  key = "tf-state-guard"
  content = "lock"
}

resource "aws_dynamodb_table" "tf-locks" {
  name           = "tf-locks-${local.env}-dynamodb"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key = "LockID"
   
  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "tf-state"
    Environment = local.env
  }
}
