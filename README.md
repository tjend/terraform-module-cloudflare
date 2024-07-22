# Terraform Moldule Cloudflare

This module makes it easier to setup Cloudflare DNS records.

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
}
```

Example `dns.yaml`:

```yaml
example.com:
  - comment: website ipv4 address
    name: example.com
    type: A
    value: 127.0.0.1
  - comment: website ipv6 address
    name: example.com
    type: AAAA
    value: ::1
  - comment: www subdomain
    name: www
    type: CNAME
    value: example.com
  - comment: email spf record for google
    name: example.com
    type: TXT
    value: v=spf1 include:_spf.google.com ~all
  - comment: email mx record for google
    name: example.com
    priority: 1
    type: MX
    value: smtp.google.com
example.org:
  - comment: website redirect to example.org using cloudflare rule
    name: example.org
    # proxied must be true for the redirect rule to work
    proxied: true
    type: CNAME
    # this value is overridden by the redirect rule
    value: rule.redirects.to.example.com
```

Example `redirects.yaml`:

```yaml
example.org:
  temporary: false
  url: https://example.com
```

## Terraform Outputs

The modules provides two outputs:

- `cloudflare-dns-hosting-status` - which shows whether each domain is active on Cloudflare
- `dnssec-status` - which shows whether each domain has DNSSEC active on Cloudflare
