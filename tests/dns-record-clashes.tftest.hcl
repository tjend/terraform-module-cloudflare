mock_provider "cloudflare" {
  mock_data "cloudflare_zones" {
    defaults = {
      zones = [{
        id   = "12345",
        name = "example.com"
      }]
    }
  }
}

# clashing A and CNAME records
run "clashing-A-and-CNAME-records-error" {
  command         = plan # only test `tofu plan`
  expect_failures = [terraform_data.dns-record-clashes]

  variables {
    domains = {
      "example.com" = [
        {
          name  = "@"
          type  = "A"
          value = "127.0.0.1"
        },
        {
          name  = "@"
          type  = "CNAME"
          value = "www"
        },
      ]
    }
  }
}

# no clashing A and CNAME records
run "no-clashing-A-and-CNAME-records" {
  command = plan # only test `tofu plan`

  assert {
    condition     = length(local.dns-record-clashes) == 0
    error_message = "Cannot define records with both A/AAAA and CNAME records. Clashing records found for: ${jsonencode(local.dns-record-clashes)}"
  }

  variables {
    domains = {
      "example.com" = [
        {
          name  = "@"
          type  = "A"
          value = "127.0.0.1"
        },
        {
          name  = "@"
          type  = "AAAA"
          value = "::1"
        },
      ],
    }
  }
}

variables {
  redirects = {}
}
