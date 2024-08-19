terraform {

  cloud {
    organization = "HCP-remote-organization"

    workspaces {
      name = "Dev_workspace"
      project = "Workspace_configs"
    }

    # how to specify a project name here?

  }



  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.31.0"
    }
  }

  required_version = "~> 1.2"

}

provider "aws" {
  region  = "us-east-1"
  profile = "eraki"
}