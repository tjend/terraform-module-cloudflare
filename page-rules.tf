# create page rules

resource "cloudflare_page_rule" "cloudflare-page-rule-disable-apps" {
  for_each = var.page_rules_disable_apps

  priority = each.value["priority"]
  target   = each.value["target"]
  zone_id = lookup(data.cloudflare_zones.zone.zones[0], "id")

  actions {
    disable_apps = each.value["status"]
  }
}

resource "cloudflare_page_rule" "cloudflare-page-rule-forwarding-url" {
  for_each = var.page_rules_forwarding_url

  priority = each.value["priority"]
  target   = each.value["target"]
  zone_id = lookup(data.cloudflare_zones.zone.zones[0], "id")

  actions {
    forwarding_url {
      status_code = each.value["status_code"]
      url         = each.value["forwarding_url"]
    }
  }
}
