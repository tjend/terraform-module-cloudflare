# compare total dns record count at cloudflare with yaml file

# get the cloudflare api token from environment variable (which is not exposed via $TF_VAR_*)
# do this instead of having to declare the same token in two environment variables
data "external" "cloudflare-api-token" {
  # we want json like this: "{ "CLOUDFLARE_API_TOKEN": "<token>" }"
  # be careful with all the shell escapes
  program = ["sh", "-c", "echo \"{ \\\"CLOUDFLARE_API_TOKEN\\\": \\\"$${CLOUDFLARE_API_TOKEN}\\\" }\""]
}

# get all dns records
# this is a bit of a hack to get dns records since the cloudflare module doesn't have the capability
data "http" "dns-records-all" {
  for_each = var.domains

  request_headers = {
    Authorization = "Bearer ${data.external.cloudflare-api-token.result.CLOUDFLARE_API_TOKEN}"
  }
  url = "https://api.cloudflare.com/client/v4/zones/${local.zone-ids[each.key]}/dns_records?per_page=50000"

  lifecycle {
    # fail if there is an error from the cloudflare api
    postcondition {
      condition     = jsondecode(self.response_body).success
      error_message = "Failed to retrieve all dns records for ${each.key} via cloudflare api."
    }

    # fail if there is more than one page of results
    postcondition {
      condition     = jsondecode(self.response_body).result_info.total_pages == 1
      error_message = "Too many dns records for ${each.key} (> 50000 records)."
    }

    # fail if dns record count don't match yaml file
    postcondition {
      condition     = !var.verify-dns-record-count || (
        jsondecode(self.response_body).result_info.count == length(each.value))
      error_message = join(" ", [
        "Records at cloudflare (${jsondecode(self.response_body).result_info.count})",
        "do not match yaml file (${length(each.value)}) for ${each.key}.",
      ])
    }
  }
}
