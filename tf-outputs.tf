output "cloudflare-dns-hosting-status" {
  value = {
    for domain, settings in cloudflare_zone_settings_override.settings :
    domain => settings.zone_status
  }
}

output "dnssec-status" {
  value = {
    for domain, dnssec in cloudflare_zone_dnssec.dnssec :
    domain => dnssec.status
  }
}

# temporary debugging

#output "dns-records" {
#  value = local.dns-records
#}

#output "domains" {
#  value = var.domains
#}

#output "zone-ids" {
#  value = local.zone-ids
#}

#output "zones" {
#  value = data.cloudflare_zones.zones
#}
