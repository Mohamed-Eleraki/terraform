# Configure aws provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure aws provider
provider "aws" {
  region  = "us-east-1"
  profile = "eraki"
}

# Create a document based on AWS-RunPatchBaseline Doc
resource "aws_ssm_document" "enza" {
  name          = "enza-AWS-RunPatchBaseline"
  document_type = "Command"
  document_format = "YAML"

  content = file("${path.module}/enza-AWS-RunPatchBaseline.file")

}