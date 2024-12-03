locals {
  env        = var.environment != "p" ? var.environment : ""
  env_prefix = var.environment != "p" ? substr(var.subscription_name, 0, 3) : ""

  connectivity_vnet_name = replace("aps-${local.env}-connectivity-${var.location_abbreviation}-vnet-01", "--", "-")
  connectivity_rg_name   = replace("rg-networking-${local.env}-${var.location_abbreviation}", "--", "-")
  route_table_routes = [
    # {
    #   name                   = "FirewallRoute"
    #   address_prefix         = "0.0.0.0/0"
    #   next_hop_type          = "VirtualAppliance"
    #   next_hop_in_ip_address = "${var.firewall_ip}"
    # }
  ]

  secrets_values_file = "./secrets.enc.json"
}