variable "domains" {
  description = "domains and their corresponding dns records"
  type = map(list(object({
    comment  = optional(string, "")
    name     = string
    priority = optional(string, null)
    proxied  = optional(bool, false)
    type     = string
    value    = string
  })))
}

variable "redirects" {
  description = "redirect from source to destination domain"
  type = map(list(object({
    comment   = optional(string, "")
    hostname  = string
    temporary = optional(bool, true)
    url       = string
  })))
}
