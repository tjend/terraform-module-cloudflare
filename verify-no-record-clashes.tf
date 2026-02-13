# The cloudflare provider doesn't stop you from attempting to create a dns name
# with both A/AAAA and CNAME records. The opentofu plan will work, but the apply
# will fail.
#
# Here we check for the intersection of A/AAAA and CNAME records, and throw an
# error if there are clashes. This will catch the issue in the opentofu plan.

locals {
  dns-records-a-aaaa = [
    for record in local.dns-records : {
      domain = "${record.domain}",
      name   = "${record.name}",
    } if contains(["A", "AAAA"], "${record.type}")
  ]

  dns-records-cname = [
    for record in local.dns-records : {
      domain = "${record.domain}",
      name   = "${record.name}",
    } if "${record.type}" == "CNAME"
  ]

  dns-record-clashes = setintersection(local.dns-records-a-aaaa, local.dns-records-cname)
}

resource "terraform_data" "dns-record-clashes" {
  # hide this resource when there are no clashes
  count = length(local.dns-record-clashes) > 0 ? 1 : 0

  lifecycle {
    precondition {
      condition     = length(local.dns-record-clashes) == 0
      error_message = "Cannot define records with both A/AAAA and CNAME records. Clashing records found for: ${jsonencode(local.dns-record-clashes)}"
    }
  }
}
