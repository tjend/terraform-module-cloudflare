resource "cloudflare_ruleset" "redirects" {
  for_each = var.redirects

  description = "Redirects ruleset"
  kind        = "zone"
  name        = "redirects"
  phase       = "http_request_dynamic_redirect"
  zone_id     = local.zone-ids[each.key]

  rules {
    action = "redirect"
    action_parameters {
      from_value {
        # 301 = permanent, 302 = temporary
        status_code = each.value.temporary == false ? 301 : 302
        target_url {
          value = each.value.url
        }
        preserve_query_string = false
      }
    }
    description = "Redirect ${each.key} to ${each.value.url}"
    enabled     = true
    expression  = "(http.host in {\"${each.key}\" \"www.${each.key}\"})"
  }
}
