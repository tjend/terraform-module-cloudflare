# create dns and mx entries

# dns zone
data "cloudflare_zones" "zone" {
  filter {
    name = var.domain
  }
}

# dns records
resource "cloudflare_record" "cloudflare-records-dns" {
  for_each = var.dns_records

  name    = each.value["name"]
  proxied = each.value["proxied"]
  value   = each.value["value"]
  type    = each.value["type"]
  ttl     = 1 # automatic
  zone_id = lookup(data.cloudflare_zones.zone.zones[0], "id")
}

# mx records
resource "cloudflare_record" "cloudflare-record-mx" {
  for_each = var.mx_records

  name     = var.domain
  priority = each.value["priority"]
  ttl      = 1 # automatic
  type     = "MX"
  value    = each.value["server"]
  zone_id = lookup(data.cloudflare_zones.zone.zones[0], "id")
}
