/*
--- Built-in Replacements ---
This file contains built-in replacements to avoid repeating the same hard-coded values.
Replacements are denoted by the dollar-dollar curly braces token (e.g. $${starter_location_01}). The following details each built-in replacements that you can use:
`starter_location_01`: This is the primary Azure location sourced from the `starter_locations` variable. This can be used to set the location of resources.
`starter_location_02` to `starter_location_##`: These are the secondary Azure locations sourced from the `starter_locations` variable. This can be used to set the location of resources.
`starter_location_01_availability_zones` to `starter_location_##_availability_zones`: These are the availability zones for the Azure locations sourced from the `starter_locations` variable. This can be used to set the availability zones of resources.
`starter_location_01_virtual_network_gateway_sku_express_route` to `starter_location_##_virtual_network_gateway_sku_express_route`: These are the default SKUs for the Express Route virtual network gateways based on the Azure locations sourced from the `starter_locations` variable. This can be used to set the SKU of the virtual network gateways.
`starter_location_01_virtual_network_gateway_sku_vpn` to `starter_location_##_virtual_network_gateway_sku_vpn`: These are the default SKUs for the VPN virtual network gateways based on the Azure locations sourced from the `starter_locations` variable. This can be used to set the SKU of the virtual network gateways.
`root_parent_management_group_id`: This is the id of the management group that the ALZ hierarchy will be nested under.
`subscription_id_identity`: The subscription ID of the subscription to deploy the identity resources to, sourced from the variable `subscription_ids`.
`subscription_id_connectivity`: The subscription ID of the subscription to deploy the connectivity resources to, sourced from the variable `subscription_ids`.
`subscription_id_management`: The subscription ID of the subscription to deploy the management resources to, sourced from the variable `subscription_ids`.
`subscription_id_security`: The subscription ID of the subscription to deploy the security resources to, sourced from the variable `subscription_ids`.
*/

/*
--- Custom Replacements ---
You can define custom replacements to use throughout the configuration.
*/
custom_replacements = {
  /*
  --- Custom Name Replacements ---
  You can define custom names and other strings to use throughout the configuration.
  You can only use the built in replacements in this section.
  NOTE: You cannot refer to another custom name in this variable.
  */
  names = {
    # Defender email security contact
    defender_email_security_contact = "replace_me@replace_me.com"

    # Resource group names
    connectivity_hub_vwan_resource_group_name    = "rg-evri-shared-hub-prod-$${starter_location_01}-network-001"
    connectivity_hub_primary_resource_group_name = "rg-evri-shared-hub-prod-$${starter_location_01}-network-001"
    dns_resource_group_name                      = "rg-evri-shared-hub-prod-$${starter_location_01}-dns-001"
    ddos_resource_group_name                     = "rg-evri-shared-hub-prod-$${starter_location_01}-ddos-001"

    # Resource names
    ddos_protection_plan_name               = "ddos-$${starter_location_01}"

    # Resource provisioning global connectivity
    ddos_protection_plan_enabled = false

    # Resource provisioning primary connectivity
    primary_firewall_enabled                              = false
    primary_virtual_network_gateway_express_route_enabled = false
    primary_virtual_network_gateway_vpn_enabled           = false
    primary_private_dns_zones_enabled                     = true
    primary_private_dns_auto_registration_zone_enabled    = false
    primary_private_dns_resolver_enabled                  = false
    primary_bastion_enabled                               = false
    primary_sidecar_virtual_network_enabled               = false

    # Resource names primary connectivity
    primary_hub_name                                   = "vhub-evri-shared-hub-prod-$${starter_location_01}-network-001"
    primary_sidecar_virtual_network_name               = "vnet-evri-shared-hub-sidecar-prod-$${starter_location_01}-network-001"
    primary_firewall_name                              = "fw-evri-shared-hub-$${starter_location_01}-network-001"
    primary_firewall_policy_name                       = "fwp-evri-shared-hub-$${starter_location_01}-network-001"
    primary_virtual_network_gateway_express_route_name = "vgw-evri-shared-hub-$${starter_location_01}-network-001"
    primary_virtual_network_gateway_vpn_name           = "vgw-evri-shared-hub-$${starter_location_01}-network-001"
    primary_private_dns_resolver_name                  = "pdr-evri-shared-hub-dns-$${starter_location_01}-network-001"
    primary_bastion_host_name                          = "bas-evri-shared-hub-$${starter_location_01}-network-001"
    primary_bastion_host_public_ip_name                = "pip-bastion-evri-shared-hub-$${starter_location_01}-network-001"

    # Private DNS Zones primary
    primary_auto_registration_zone_name = "$${starter_location_01}.azure.local"

    # IP Ranges Primary
    # Regional Address Space: 10.0.0.0/16
    primary_hub_address_space                          = "10.0.0.0/22"
    primary_side_car_virtual_network_address_space     = "10.0.4.0/22"
    primary_bastion_subnet_address_prefix              = "10.0.4.0/26"
    primary_private_dns_resolver_subnet_address_prefix = "10.0.4.64/28"
  }

  /*
  --- Custom Resource Group Identifier Replacements ---
  You can define custom resource group identifiers to use throughout the configuration.
  You can only use the templated variables and custom names in this section.
  NOTE: You cannot refer to another custom resource group identifier in this variable.
  */
  resource_group_identifiers = {
    ddos_protection_plan_resource_group_id = "/subscriptions/$${subscription_id_connectivity}/resourcegroups/$${ddos_resource_group_name}"
  }

  /*
  --- Custom Resource Identifier Replacements ---
  You can define custom resource identifiers to use throughout the configuration.
  You can only use the templated variables, custom names and customer resource group identifiers in this variable.
  NOTE: You cannot refer to another custom resource identifier in this variable.
  */
  resource_identifiers = {}
}

enable_telemetry = false

/*
--- Tags ---
This variable can be used to apply tags to all resources that support it. Some resources allow overriding these tags.
*/
tags = {
  deployed_by = "terraform"
  source      = "Azure Landing Zones Accelerator"
}

/*
--- Connectivity - Virtual WAN ---
You can use this section to customize the virtual wan networking that will be deployed.
*/
# connectivity_type = "virtual_wan"
connectivity_type = "none"

connectivity_resource_groups = {
  ddos = {
    name     = "$${ddos_resource_group_name}"
    location = "$${starter_location_01}"
    settings = {
      enabled = "$${ddos_protection_plan_enabled}"
    }
  }
  vwan = {
    name     = "$${connectivity_hub_vwan_resource_group_name}"
    location = "$${starter_location_01}"
    settings = {
      enabled = true
    }
  }
  vwan_hub_primary = {
    name     = "$${connectivity_hub_primary_resource_group_name}"
    location = "$${starter_location_01}"
    settings = {
      enabled = true
    }
  }
  dns = {
    name     = "$${dns_resource_group_name}"
    location = "$${starter_location_01}"
    settings = {
      enabled = "$${primary_private_dns_zones_enabled}"
    }
  }
}

virtual_wan_settings = {
  name                = "vwan-evri-shared-hub-prod-$${starter_location_01}-001"
  resource_group_name = "$${connectivity_hub_vwan_resource_group_name}"
  location            = "$${starter_location_01}"
  ddos_protection_plan = {
    enabled             = "$${ddos_protection_plan_enabled}"
    name                = "$${ddos_protection_plan_name}"
    resource_group_name = "$${ddos_resource_group_name}"
    location            = "$${starter_location_01}"
  }
}

virtual_wan_virtual_hubs = {
  primary = {
    hub = {
      name = "$${primary_hub_name}"
      /*
      NOTE: We are defaulting to a separate resource group for the hub per best practice for resiliency
      However, there is a known limitation with the portal experience: https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-faq#can-hubs-be-created-in-different-resource-groups-in-virtual-wan
      If you prefer to use the same resource group as the vwan, then set this to `$${connectivity_hub_vwan_resource_group_name}`
      */
      resource_group = "$${connectivity_hub_primary_resource_group_name}"
      location       = "$${starter_location_01}"
      address_prefix = "$${primary_hub_address_space}"
    }
    firewall = {
      enabled  = "$${primary_firewall_enabled}"
      name     = "$${primary_firewall_name}"
      sku_name = "AZFW_Hub"
      sku_tier = "Standard"
      zones    = "$${starter_location_01_availability_zones}"
    }
    firewall_policy = {
      name = "$${primary_firewall_policy_name}"
    }
    virtual_network_gateways = {
      express_route = {
        enabled = "$${primary_virtual_network_gateway_express_route_enabled}"
        name    = "$${primary_virtual_network_gateway_express_route_name}"
      }
      vpn = {
        enabled = "$${primary_virtual_network_gateway_vpn_enabled}"
        name    = "$${primary_virtual_network_gateway_vpn_name}"
      }
    }
    private_dns_zones = {
      enabled = "$${primary_private_dns_zones_enabled}"
      dns_zones = {
        resource_group_name = "$${dns_resource_group_name}"
        private_link_private_dns_zones_regex_filter = {
          enabled      = true
          regex_filter = "^(privatelink\\.(blob|file|queue|table)\\.core\\.windows\\.net)$"
        }
      }
      auto_registration_zone_enabled = "$${primary_private_dns_auto_registration_zone_enabled}"
      auto_registration_zone_name    = "$${primary_auto_registration_zone_name}"
    }
    private_dns_resolver = {
      enabled               = "$${primary_private_dns_resolver_enabled}"
      subnet_address_prefix = "$${primary_private_dns_resolver_subnet_address_prefix}"
      dns_resolver = {
        name = "$${primary_private_dns_resolver_name}"
      }
    }
    bastion = {
      enabled               = "$${primary_bastion_enabled}"
      subnet_address_prefix = "$${primary_bastion_subnet_address_prefix}"
      bastion_host = {
        name  = "$${primary_bastion_host_name}"
        zones = "$${starter_location_01_availability_zones}"
      }
      bastion_public_ip = {
        name  = "$${primary_bastion_host_public_ip_name}"
        zones = "$${starter_location_01_availability_zones}"
      }
    }
    side_car_virtual_network = {
      enabled       = "$${primary_sidecar_virtual_network_enabled}"
      name          = "$${primary_sidecar_virtual_network_name}"
      address_space = ["$${primary_side_car_virtual_network_address_space}"]
      /*
      virtual_network_connection_settings = {
        name = "private_dns_vnet_primary"  # Backwards compatibility
      }
      */
    }
  }
}