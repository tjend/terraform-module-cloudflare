resource "cloudflare_ruleset" "redirects" {
  # one cloudflare_ruleset resource per domain
  for_each = var.redirects

  description = "Redirects ruleset for the ${each.key} domain"
  kind        = "zone"
  name        = "redirects-${each.key}"
  phase       = "http_request_dynamic_redirect"
  zone_id     = local.zone-ids[each.key]

  # create multiple "rules", one per hostname
  dynamic "rules" {
    for_each = each.value

    content {
      action = "redirect"
      action_parameters {
        from_value {
          # 301 = permanent, 302 = temporary
          status_code = rules.value.temporary == false ? 301 : 302
          target_url {
            value = rules.value.url
          }
          preserve_query_string = false
        }
      }
      description = "Redirect ${rules.value.hostname} to ${rules.value.url}"
      enabled     = true
      expression  = "(http.host eq \"${rules.value.hostname}\")"
    }
  }
}
