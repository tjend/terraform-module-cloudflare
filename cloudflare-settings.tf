# enable for all zones:
#   - Always Use HTTPS
#   - HTTP Strict Transport Security (HSTS)
#   - DNSSEC

resource "cloudflare_zone_dnssec" "dnssec" {
  for_each = var.domains

  zone_id = local.zone-ids[each.key]
}

resource "cloudflare_zone_settings_override" "settings" {
  for_each = var.domains

  settings {
    always_use_https = "on"
    security_header {
      enabled = true
    }
  }
  zone_id = local.zone-ids[each.key]
}
