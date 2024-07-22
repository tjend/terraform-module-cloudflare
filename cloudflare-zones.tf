locals {
  # maps domain names to zone ids
  zone-ids = {
    for zone in data.cloudflare_zones.zones.zones :
    zone.name => zone.id
  }
}

data "cloudflare_zones" "zones" {
  filter {
    # all zones
  }
}
