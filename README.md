# Terraform Module Cloudflare

This module makes it easier to setup Cloudflare DNS records and add simple hostname redirects.

It also enables for all zones:

- Always Use HTTPS
- HTTP Strict Transport Security (HSTS)
- DNSSEC

## Usage

Create a module, passing in `domains` and `redirects`:

```shell
module "dns" {
  source = "github.com/tjend/terraform-module-cloudflare"

  domains   = yamldecode(file("dns.yaml"))
  redirects = yamldecode(file("redirects.yaml"))

  # do not verify dns record count
  #verify-dns-record-count = false
}
```

Example `dns.yaml`:

```yaml
example.com:
  - comment: website ipv4 address
    # "@" is replaced by the domain name, similarly to the cloudflare website
    name: "@"
    type: A
    value: 127.0.0.1
  - comment: website ipv6 address
    name: "@"
    type: AAAA
    value: ::1
  - comment: www redirects to non-www using cloudflare rule
    name: www
    # proxied must be true for the redirect rule to work
    proxied: true
    type: CNAME
    # this value is overridden by the redirect rule
    value: rule.redirects.to.example.com
  - comment: email spf record for google
    name: "@"
    type: TXT
    value: v=spf1 include:_spf.google.com ~all
  - comment: email mx record for google
    name: "@"
    priority: 1
    type: MX
    value: smtp.google.com
example.org:
  - comment: website redirect to example.com using cloudflare rule
    name: "@"
    # proxied must be true for the redirect rule to work
    proxied: true
    type: CNAME
    # this value is overridden by the redirect rule
    value: rule.redirects.to.example.com
  - comment: website redirect to example.com using cloudflare rule
    name: www
    # proxied must be true for the redirect rule to work
    proxied: true
    type: CNAME
    # this value is overridden by the redirect rule
    value: rule.redirects.to.example.com
```

Example `redirects.yaml`:

```yaml
example.com:
  - comment: redirect www.example.com to https://example.com/
    hostname: www.example.org
    temporary: false
    url: https://example.com/
example.org:
  - comment: redirect example.org to https://example.com/
    hostname: example.org
    temporary: false
    url: https://example.com
  - comment: redirect www.example.org to https://example.com/
    hostname: www.example.org
    temporary: false
    url: https://example.com
```

## Terraform Outputs

The modules provides two outputs:

- `cloudflare-dns-hosting-status` - which shows whether each domain is active on Cloudflare
- `dnssec-status` - which shows whether each domain has DNSSEC active on Cloudflare

## Verify DNS Record Count

This module will check, by default, that the dns record count at Cloudflare matches the number of records in `var.domains`. This allows you to detect any manually added records. Details will be output for any extra records found (to make importing easier).

If you manage records outside of Terraform, you can disable this check by passing in `verify-dns-record-count = false` to the module.
