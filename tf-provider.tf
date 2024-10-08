terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      # specify the minimum version containing the features relied on
      version = ">= 4.35.0"
      # find latest version number at https://github.com/cloudflare/terraform-provider-cloudflare
    }
  }
}
