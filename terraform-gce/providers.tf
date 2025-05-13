# This file defines the required versions for Terraform and its providers.
# It ensures that your infrastructure code is run with compatible versions,
# preventing unexpected behavior or errors due to version mismatches.

# Alternatively this information can be defined in versions.tf 

terraform {
  required_version = ">= 1.1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.00.0"
    }
  }
}
