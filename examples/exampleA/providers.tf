# require the cloudflare provider to access resources and data
terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.11.0"
    }
  }
}
