# basic example of create dns and page rules with google mx servers
variable "dns-example_com" {
  type = map(object({
    type    = string
    name    = string
    value   = string
    proxied = bool
  }))

  default = {
    APEX-ipv4 = {
      # example.com A 127.0.0.1
      type    = "A"
      name    = "example.com"
      value   = "127.0.0.1"
      proxied = false
    },
    APEX-ipv6 = {
      # example.com AAAA ::1
      type    = "AAAA"
      name    = "example.com"
      value   = "::1"
      proxied = false
    },
    localhost = {
      # localhost.example.com A 127.0.0.1
      type    = "A"
      name    = "localhost"
      value   = "127.0.0.1"
      proxied = true
    },
    www = {
      # www.example.com CNAME page.rule.overrides.this
      type    = "CNAME"
      name    = "www"
      value   = "page.rule.overrides.this"
      proxied = true
    },
    TXT = {
      # example.com TXT v=spf1 include:_spf.google.com ~all
      type    = "TXT"
      name    = "example.com"
      value   = "v=spf1 include:_spf.google.com ~all"
      proxied = false
    }
  }
}

variable "page_rules_disable_apps-example_com" {
  type = map(object({
    priority = number
    target   = string
    status   = bool
  }))

  default = {
    disable_apps-localhost = {
      priority = 1
      target   = "https://localhost.example.com/*"
      status   = true
    }
  }
}

variable "page_rules_forwarding_url-example_com" {
  type = map(object({
    priority       = number
    target         = string
    forwarding_url = string
    status_code    = number
  }))

  default = {
    redirect_www = {
      priority       = 2
      target         = "https://www.example.com/*"
      forwarding_url = "https://example.com/"
      status_code    = 301 # permanent redirect
    }
  }
}

# use terraform-module-cloudflare to setup dns
module "module-dns-example_com" {
  source = "github.com/tjend/terraform-module-cloudflare"

  dns_records               = var.dns-example_com
  domain                    = "example.com"
  page_rules_disable_apps   = var.page_rules_disable_apps-example_com
  page_rules_forwarding_url = var.page_rules_forwarding_url-example_com
}
