terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      # keep below version 5, which isn't forward compatible
      version = "< 5.0.0"
      # find latest version number at https://github.com/cloudflare/terraform-provider-cloudflare
    }
  }
}
