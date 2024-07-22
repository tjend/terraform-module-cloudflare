locals {
  # flat list of all domains and dns records
  dns-records = {
    for item in flatten([
      for domain, records in var.domains : [
        for record in records : {
          "comment"  = record.comment
          "domain"   = domain
          "name"     = record.name
          "priority" = try(record.priority, null)
          "proxied"  = record.proxied
          "type"     = record.type
          "value"    = record.value
        }
      ]
    ]) : "${item.domain}-${item.type}-${item.name}-${item.comment}" => item
  }
}

resource "cloudflare_record" "records" {
  for_each = local.dns-records

  comment  = each.value.comment
  name     = each.value.name
  priority = each.value.priority
  proxied  = each.value.proxied
  ttl      = 1 # automatic
  type     = each.value.type
  value    = each.value.value
  zone_id  = local.zone-ids[each.value.domain]
}
