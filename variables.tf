# module variables

variable "dns_records" {
  description = "dns records and their corresponding proxied setting"
  type        = map(object({
    name    = string
    proxied = bool
    type    = string
    value   = string
  }))
}

variable "domain" {
  description = "domain name"
  type        = string
}

variable "mx_records" {
  description = "mx records and corresponding priorities"
  type        = map(object({
    priority = number
    server   = string
  }))
  default     = {
    1 = {
      server   = "aspmx.l.google.com",
      priority = 1
    },
    2 = {
      server   = "alt1.aspmx.l.google.com"
      priority = 5
    },
    3 = {
      server   = "alt2.aspmx.l.google.com"
      priority = 5
    },
    4 = {
      server   = "alt3.aspmx.l.google.com"
      priority = 10
    },
    5 = {
      server   = "alt4.aspmx.l.google.com"
      priority = 10
    },
  }
}

variable "page_rules_disable_apps" {
  description = "page rules to disable apps"
  type        = map(object({
    priority = number
    target   = string
    status   = bool
  }))
}

variable "page_rules_forwarding_url" {
  description = "page rules to forward to a url"
  type        = map(object({
    priority       = number
    target         = string
    forwarding_url = string
    status_code    = number
  }))
}
