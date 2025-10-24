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
    management_resource_group_name               = "rg-evri-shared-management-prod-$${starter_location_01}-network-001"
    connectivity_hub_vwan_resource_group_name    = "rg-evri-shared-hub-prod-$${starter_location_01}-network-001"
    connectivity_hub_primary_resource_group_name = "rg-evri-shared-hub-prod-$${starter_location_01}-network-001"
    dns_resource_group_name                      = "rg-hub-dns-$${starter_location_01}"
    ddos_resource_group_name                     = "rg-hub-ddos-$${starter_location_01}"
    asc_export_resource_group_name               = "rg-asc-export-$${starter_location_01}"

    # Resource names
    log_analytics_workspace_name            = "law-management-$${starter_location_01}"
    ddos_protection_plan_name               = "ddos-$${starter_location_01}"
    ama_user_assigned_managed_identity_name = "uami-management-ama-$${starter_location_01}"
    dcr_change_tracking_name                = "dcr-change-tracking"
    dcr_defender_sql_name                   = "dcr-defender-sql"
    dcr_vm_insights_name                    = "dcr-vm-insights"

    # Resource provisioning global connectivity
    ddos_protection_plan_enabled = false

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
    management_resource_group_id           = "/subscriptions/$${subscription_id_management}/resourcegroups/$${management_resource_group_name}"
    ddos_protection_plan_resource_group_id = "/subscriptions/$${subscription_id_connectivity}/resourcegroups/$${ddos_resource_group_name}"
  }

  /*
  --- Custom Resource Identifier Replacements ---
  You can define custom resource identifiers to use throughout the configuration.
  You can only use the templated variables, custom names and customer resource group identifiers in this variable.
  NOTE: You cannot refer to another custom resource identifier in this variable.
  */
  resource_identifiers = {
    ama_change_tracking_data_collection_rule_id = "$${management_resource_group_id}/providers/Microsoft.Insights/dataCollectionRules/$${dcr_change_tracking_name}"
    ama_mdfc_sql_data_collection_rule_id        = "$${management_resource_group_id}/providers/Microsoft.Insights/dataCollectionRules/$${dcr_defender_sql_name}"
    ama_vm_insights_data_collection_rule_id     = "$${management_resource_group_id}/providers/Microsoft.Insights/dataCollectionRules/$${dcr_vm_insights_name}"
    ama_user_assigned_managed_identity_id       = "$${management_resource_group_id}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/$${ama_user_assigned_managed_identity_name}"
    log_analytics_workspace_id                  = "$${management_resource_group_id}/providers/Microsoft.OperationalInsights/workspaces/$${log_analytics_workspace_name}"
    ddos_protection_plan_id                     = "$${ddos_protection_plan_resource_group_id}/providers/Microsoft.Network/ddosProtectionPlans/$${ddos_protection_plan_name}"
  }
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
--- Management Resources ---
You can use this section to customize the management resources that will be deployed.
*/
management_resource_settings = {
  enabled                      = true
  location                     = "$${starter_location_01}"
  log_analytics_workspace_name = "$${log_analytics_workspace_name}"
  resource_group_name          = "$${management_resource_group_name}"
  user_assigned_managed_identities = {
    ama = {
      name = "$${ama_user_assigned_managed_identity_name}"
    }
  }
  data_collection_rules = {
    change_tracking = {
      name = "$${dcr_change_tracking_name}"
    }
    defender_sql = {
      name = "$${dcr_defender_sql_name}"
    }
    vm_insights = {
      name = "$${dcr_vm_insights_name}"
    }
  }
}

/*
--- Management Groups and Policy ---
You can use this section to customize the management groups and policies that will be deployed.
You can further configure management groups and policy by supplying a `lib` folder. This is detailed in the Accelerator documentation.
*/
management_group_settings = {
  enabled = true
  # This is the name of the architecture that will be used to deploy the management resources.
  # It refers to the alz_custom.alz_architecture_definition.yaml file in the lib folder.
  # Do not change this value unless you have created another architecture definition
  # with the name value specified below.
  architecture_name  = "alz_custom"
  location           = "$${starter_location_01}"
  parent_resource_id = "$${root_parent_management_group_id}"
  policy_default_values = {
    ama_change_tracking_data_collection_rule_id = "$${ama_change_tracking_data_collection_rule_id}"
    ama_mdfc_sql_data_collection_rule_id        = "$${ama_mdfc_sql_data_collection_rule_id}"
    ama_vm_insights_data_collection_rule_id     = "$${ama_vm_insights_data_collection_rule_id}"
    ama_user_assigned_managed_identity_id       = "$${ama_user_assigned_managed_identity_id}"
    ama_user_assigned_managed_identity_name     = "$${ama_user_assigned_managed_identity_name}"
    log_analytics_workspace_id                  = "$${log_analytics_workspace_id}"
    ddos_protection_plan_id                     = "$${ddos_protection_plan_id}"
    private_dns_zone_subscription_id            = "$${subscription_id_connectivity}"
    private_dns_zone_region                     = "$${starter_location_01}"
    private_dns_zone_resource_group_name        = "$${dns_resource_group_name}"
  }
  subscription_placement = {
    evri-identity = {
      subscription_id       = "$${subscription_id_identity}"
      management_group_name = "evri-identity"
    }
    evri-connectivity = {
      subscription_id       = "$${subscription_id_connectivity}"
      management_group_name = "evri-connectivity"
    }
    evri-management = {
      subscription_id       = "$${subscription_id_management}"
      management_group_name = "evri-management"
    }
    evri-security = {
      subscription_id       = "$${subscription_id_security}"
      management_group_name = "evri-security"
    }
  }
  policy_assignments_to_modify = {
    "evri" = {
      policy_assignments = {
        # ALZ inbuilt policies
        "Audit-ResourceRGLocation" = { enforcement_mode = "DoNotEnforce" }
        "Audit-TrustedLaunch"      = { enforcement_mode = "DoNotEnforce" }
        "Audit-UnusedResources"    = { enforcement_mode = "DoNotEnforce" }
        "Audit-ZoneResiliency"     = { enforcement_mode = "DoNotEnforce" }
        "Deny-Classic-Resources"   = { enforcement_mode = "DoNotEnforce" }
        "Deny-UnmanagedDisk"       = { enforcement_mode = "DoNotEnforce" }
        "Deploy-ASC-Monitoring-Tp" = { enforcement_mode = "DoNotEnforce" }
        "Deploy-AzActivity-Log"    = { enforcement_mode = "DoNotEnforce" }
        "Deploy-Diag-LogsCat"      = { enforcement_mode = "DoNotEnforce" }
        "Deploy-MDEndpoints"       = { enforcement_mode = "DoNotEnforce" }
        "Deploy-MDEndpointsAMA"    = { enforcement_mode = "DoNotEnforce" }

        "Deploy-MDFC-Config-H224" = {
          enforcement_mode = "DoNotEnforce"
          parameters = {
            ascExportResourceGroupName                  = "$${asc_export_resource_group_name}"
            ascExportResourceGroupLocation              = "$${starter_location_01}"
            emailSecurityContact                        = "$${defender_email_security_contact}"
            enableAscForServers                         = "DeployIfNotExists"
            enableAscForServersVulnerabilityAssessments = "DeployIfNotExists"
            enableAscForSql                             = "DeployIfNotExists"
            enableAscForAppServices                     = "DeployIfNotExists"
            enableAscForStorage                         = "DeployIfNotExists"
            enableAscForContainers                      = "DeployIfNotExists"
            enableAscForKeyVault                        = "DeployIfNotExists"
            enableAscForSqlOnVm                         = "DeployIfNotExists"
            enableAscForArm                             = "DeployIfNotExists"
            enableAscForOssDb                           = "DeployIfNotExists"
            enableAscForCosmosDbs                       = "DeployIfNotExists"
            enableAscForCspm                            = "DeployIfNotExists"
          }
        }

        "Deploy-MDFC-OssDb"        = { enforcement_mode = "DoNotEnforce" }
        "Deploy-MDFC-SqlAtp"       = { enforcement_mode = "DoNotEnforce" }
        "Deploy-SvcHealth-BuiltIn" = { enforcement_mode = "DoNotEnforce" }
        "Enforce-ACSB"             = { enforcement_mode = "DoNotEnforce" }

        # Evri custom policies -------------------------------------------------
        "PA-Evri-Tagging-Baseline" = {
          enforcement_mode = "DoNotEnforce"
        }
        "PA-Evri-Compute-Baseline" = {
          enforcement_mode = "DoNotEnforce"
          parameters = {
            approvedExtensions = []
          }
        }
        "PA-Evri-General-Baseline" = {
          enforcement_mode = "DoNotEnforce"
          parameters = {
            listOfAllowedLocations = [
              "UK South",
              "UK West",
            ]
            listOfAllowedSKUs = [
              "Standard_D2s_v5",
              "Standard_D4s_v5"
            ]
          }
        }
        "PA-Evri-Sec-Baseline" = {
          enforcement_mode = "DoNotEnforce"
        }
        "PA-Evri-Storage-Baseline" = {
          enforcement_mode = "DoNotEnforce"
        }
        "PA-Evri-Cost-Baseline" = {
          enforcement_mode = "DoNotEnforce"
        }
      }
    }

    "evri-platform" = {
      policy_assignments = {
        "DenyAction-DeleteUAMIAMA" = { enforcement_mode = "DoNotEnforce" }
        "Deploy-GuestAttest"       = { enforcement_mode = "DoNotEnforce" }
        "Deploy-MDFC-DefSQL-AMA"   = { enforcement_mode = "DoNotEnforce" }
        "Deploy-VM-ChangeTrack"    = { enforcement_mode = "DoNotEnforce" }
        "Deploy-VM-Monitoring"     = { enforcement_mode = "DoNotEnforce" }
        "Deploy-vmArc-ChangeTrack" = { enforcement_mode = "DoNotEnforce" }
        "Deploy-vmHybr-Monitoring" = { enforcement_mode = "DoNotEnforce" }
        "Deploy-VMSS-ChangeTrack"  = { enforcement_mode = "DoNotEnforce" }
        "Deploy-VMSS-Monitoring"   = { enforcement_mode = "DoNotEnforce" }
        "Enable-AUM-CheckUpdates"  = { enforcement_mode = "DoNotEnforce" }
        "Enforce-ASR"              = { enforcement_mode = "DoNotEnforce" }
        "Enforce-Encrypt-CMK0"     = { enforcement_mode = "DoNotEnforce" }

        "Enforce-GR-APIM0"        = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-AppServices0" = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-Automation0"  = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-BotService0"  = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-CogServ0"     = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-Compute0"     = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-ContApps0"    = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-ContInst0"    = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-ContReg0"     = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-CosmosDb0"    = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-DataExpl0"    = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-DataFactory0" = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-EventGrid0"   = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-EventHub0"    = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-KeyVault"     = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-KeyVaultSup0" = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-Kubernetes0"  = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-MachLearn0"   = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-MySQL0"       = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-Network0"     = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-OpenAI0"      = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-PostgreSQL0"  = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-ServiceBus0"  = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-SQL0"         = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-Storage0"     = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-Synapse0"     = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-VirtualDesk0" = { enforcement_mode = "DoNotEnforce" }
        "Enforce-Subnet-Private"  = { enforcement_mode = "DoNotEnforce" }
      }
    }

    "evri-landingzones" = {
      policy_assignments = {
        "Audit-AppGW-WAF"          = { enforcement_mode = "DoNotEnforce" }
        "Deny-IP-forwarding"       = { enforcement_mode = "DoNotEnforce" }
        "Deny-MgmtPorts-Internet"  = { enforcement_mode = "DoNotEnforce" }
        "Deny-Priv-Esc-AKS"        = { enforcement_mode = "DoNotEnforce" }
        "Deny-Privileged-AKS"      = { enforcement_mode = "DoNotEnforce" }
        "Deny-Storage-http"        = { enforcement_mode = "DoNotEnforce" }
        "Deny-Subnet-Without-Nsg"  = { enforcement_mode = "DoNotEnforce" }
        "Deploy-AzSqlDb-Auditing"  = { enforcement_mode = "DoNotEnforce" }
        "Deploy-GuestAttest"       = { enforcement_mode = "DoNotEnforce" }
        "Deploy-MDFC-DefSQL-AMA"   = { enforcement_mode = "DoNotEnforce" }
        "Deploy-SQL-TDE"           = { enforcement_mode = "DoNotEnforce" }
        "Deploy-SQL-Threat"        = { enforcement_mode = "DoNotEnforce" }
        "Deploy-VM-Backup"         = { enforcement_mode = "DoNotEnforce" }
        "Deploy-VM-ChangeTrack"    = { enforcement_mode = "DoNotEnforce" }
        "Deploy-VM-Monitoring"     = { enforcement_mode = "DoNotEnforce" }
        "Deploy-vmArc-ChangeTrack" = { enforcement_mode = "DoNotEnforce" }
        "Deploy-vmHybr-Monitoring" = { enforcement_mode = "DoNotEnforce" }
        "Deploy-VMSS-ChangeTrack"  = { enforcement_mode = "DoNotEnforce" }
        "Deploy-VMSS-Monitoring"   = { enforcement_mode = "DoNotEnforce" }
        "Enable-AUM-CheckUpdates"  = { enforcement_mode = "DoNotEnforce" }
        "Enable-DDoS-VNET"         = { enforcement_mode = "DoNotEnforce" }
        "Enforce-AKS-HTTPS"        = { enforcement_mode = "DoNotEnforce" }
        "Enforce-ASR"              = { enforcement_mode = "DoNotEnforce" }
        "Enforce-Encrypt-CMK0"     = { enforcement_mode = "DoNotEnforce" }

        "Enforce-GR-APIM0"        = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-AppServices0" = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-Automation0"  = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-BotService0"  = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-CogServ0"     = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-Compute0"     = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-ContApps0"    = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-ContInst0"    = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-ContReg0"     = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-CosmosDb0"    = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-DataExpl0"    = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-DataFactory0" = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-EventGrid0"   = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-EventHub0"    = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-KeyVault"     = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-KeyVaultSup0" = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-Kubernetes0"  = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-MachLearn0"   = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-MySQL0"       = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-Network0"     = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-OpenAI0"      = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-PostgreSQL0"  = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-ServiceBus0"  = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-SQL0"         = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-Storage0"     = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-Synapse0"     = { enforcement_mode = "DoNotEnforce" }
        "Enforce-GR-VirtualDesk0" = { enforcement_mode = "DoNotEnforce" }

        "Enforce-Subnet-Private" = { enforcement_mode = "DoNotEnforce" }
        "Enforce-TLS-SSL-Q225"   = { enforcement_mode = "DoNotEnforce" }
      }
    }

    "evri-corp" = {
      policy_assignments = {
        "Audit-PeDnsZones"         = { enforcement_mode = "DoNotEnforce" }
        "Deny-HybridNetworking"    = { enforcement_mode = "DoNotEnforce" }
        "Deny-Public-Endpoints"    = { enforcement_mode = "DoNotEnforce" }
        "Deny-Public-IP-On-NIC"    = { enforcement_mode = "DoNotEnforce" }
        "Deploy-Private-DNS-Zones" = { enforcement_mode = "DoNotEnforce" }
      }
    }

    "evri-identity" = {
      policy_assignments = {
        "Deny-MgmtPorts-Internet" = { enforcement_mode = "DoNotEnforce" }
        "Deny-Public-IP"          = { enforcement_mode = "DoNotEnforce" }
        "Deny-Subnet-Without-Nsg" = { enforcement_mode = "DoNotEnforce" }
        "Deploy-VM-Backup"        = { enforcement_mode = "DoNotEnforce" }
      }
    }

    "evri-connectivity" = {
      policy_assignments = {
        "Enable-DDoS-VNET" = { enforcement_mode = "DoNotEnforce" }
      }
    }

    "evri-decommissioned" = {
      policy_assignments = {
        "Enforce-ALZ-Decomm" = { enforcement_mode = "DoNotEnforce" }
      }
    }

    "evri-sandbox" = {
      policy_assignments = {
        "Enforce-ALZ-Sandbox" = { enforcement_mode = "DoNotEnforce" }
      }
    }
  }

  # Set of objects defining policy definition IDs (GUIDs) and parameter names for which automatic role assignment generation should be SKIPPED.
  # As we are only deploying a subset of private DNS zones, we need to skip role assignments for the ones we are not using (otherwise error).
  # Comment out ('#') the lines corresponding to DNS Zones you ARE using.
  override_policy_definition_parameter_assign_permissions_unset = [
    # ============================================================================================= #
    # ===================================== PRIVATE DNS ZONES ===================================== #
    # ============================================================================================= #
    # --- Azure File Sync --- (privatelink.afs.azure.net)
    { definition_name = "06695360-db88-47f6-b976-7500d4297475", parameter_name = "privateDnsZoneId" },
    # --- Azure Automation --- (privatelink.azure-automation.net)
    { definition_name = "6dd01e4f-1be1-4e80-9d0b-d109e04cb064", parameter_name = "privateDnsZoneId" },
    # --- Azure Cosmos DB (Multiple APIs) --- (privatelink.*.cosmos.azure.com, privatelink.documents.azure.com)
    { definition_name = "a63cc0bd-cda4-4178-b705-37dc439d3e0f", parameter_name = "privateDnsZoneId" },
    # --- Azure Data Factory --- (privatelink.datafactory.azure.net, privatelink.adf.azure.com)
    { definition_name = "86cd96e1-1745-420d-94d4-d3f2fe415aa4", parameter_name = "privateDnsZoneId" },
    # --- Azure Databricks --- (privatelink.azuredatabricks.net)
    { definition_name = "0eddd7f3-3d9b-4927-a07a-806e8ac9486c", parameter_name = "privateDnsZoneId" },
    # --- Azure HDInsight --- (privatelink.azurehdinsight.net)
    { definition_name = "43d6e3bd-fc6a-4b44-8b4d-2151d8736a11", parameter_name = "privateDnsZoneId" },
    # --- Azure Migrate --- (privatelink.prod.migration.windowsazure.com)
    { definition_name = "7590a335-57cf-4c95-babd-ecbc8fafeb1f", parameter_name = "privateDnsZoneId" },
    # --- Azure Storage Blob --- (privatelink.blob.core.windows.net)
    { definition_name = "75973700-529f-4de2-b794-fb9b6781b6b0", parameter_name = "privateDnsZoneId" }, # Primary Blob
    { definition_name = "d847d34b-9337-4e2d-99a5-767e5ac9c582", parameter_name = "privateDnsZoneId" }, # Secondary Blob
    # --- Azure Storage Queue --- (privatelink.queue.core.windows.net)
    { definition_name = "bcff79fb-2b0d-47c9-97e5-3023479b00d1", parameter_name = "privateDnsZoneId" }, # Primary Queue
    { definition_name = "da9b4ae8-5ddc-48c5-b9c0-25f8abf7a3d6", parameter_name = "privateDnsZoneId" }, # Secondary Queue
    # --- Azure Storage File --- (privatelink.file.core.windows.net)
    { definition_name = "6df98d03-368a-4438-8730-a93c4d7693d6", parameter_name = "privateDnsZoneId" },
    # --- Azure Storage Static Web --- (privatelink.web.core.windows.net)
    { definition_name = "9adab2a5-05ba-4fbd-831a-5bf958d04218", parameter_name = "privateDnsZoneId" },
    { definition_name = "d19ae5f1-b303-4b82-9ca8-7682749faf0c", parameter_name = "privateDnsZoneId" },
    # --- Azure Storage DFS --- (privatelink.dfs.core.windows.net)
    { definition_name = "83c6fe0f-2316-444a-99a1-1ecd8a7872ca", parameter_name = "privateDnsZoneId" }, # Primary DFS
    { definition_name = "90bd4cb3-9f59-45f7-a6ca-f69db2726671", parameter_name = "privateDnsZoneId" }, # Secondary DFS
    # --- Azure Synapse Analytics --- (privatelink.sql.azuresynapse.net, privatelink.dev.azuresynapse.net)
    { definition_name = "1e5ed725-f16c-478b-bd4b-7bfa2f7940b9", parameter_name = "privateDnsZoneId" },
    # --- Azure Media Services --- (privatelink.media.azure.net)
    { definition_name = "b4a7f6c1-585e-4177-ad5b-c2c93f4bb991", parameter_name = "privateDnsZoneId" },
    # --- Azure Monitor --- (Multiple zones) ALL (Safer unless specifically needed & configured)
    { definition_name = "437914ee-c176-4fff-8986-7e05eb971365", parameter_name = "privateDnsZoneId1" },
    { definition_name = "437914ee-c176-4fff-8986-7e05eb971365", parameter_name = "privateDnsZoneId2" },
    { definition_name = "437914ee-c176-4fff-8986-7e05eb971365", parameter_name = "privateDnsZoneId3" },
    { definition_name = "437914ee-c176-4fff-8986-7e05eb971365", parameter_name = "privateDnsZoneId4" },
    { definition_name = "437914ee-c176-4fff-8986-7e05eb971365", parameter_name = "privateDnsZoneId5" },
    # --- Azure Web PubSub --- (privatelink.webpubsub.azure.com)
    { definition_name = "0b026355-49cb-467b-8ac4-f777874e175a", parameter_name = "privateDnsZoneId" },
    # --- Azure Batch --- (privatelink.batch.azure.com)
    { definition_name = "4ec38ebc-381f-45ee-81a4-acbc4be878f8", parameter_name = "privateDnsZoneId" },
    # --- Azure App Configuration --- (privatelink.azconfig.io)
    { definition_name = "7a860e27-9ca2-4fc6-822d-c2d248c300df", parameter_name = "privateDnsZoneId" },
    # --- Azure Site Recovery (Generic) --- (privatelink.siterecovery.windowsazure.com)
    { definition_name = "942bd215-1a66-44be-af65-6a1c0318dbe2", parameter_name = "privateDnsZoneId" },
    # --- Azure IoT DPS --- (privatelink.azure-devices-provisioning.net)
    { definition_name = "aaa64d2d-2fa3-45e5-b332-0b031b9b30e8", parameter_name = "privateDnsZoneId" },
    # --- Azure Key Vault --- (privatelink.vaultcore.azure.net)
    { definition_name = "ac673a9a-f77d-4846-b2d8-a57f8e1c01d4", parameter_name = "privateDnsZoneId" },
    # --- Azure SignalR --- (privatelink.service.signalr.net)
    { definition_name = "b0e86710-7fb7-4a6c-a064-32e9b829509e", parameter_name = "privateDnsZoneId" },
    # --- Azure App Service --- (privatelink.azurewebsites.net)
    { definition_name = "b318f84a-b872-429b-ac6d-a01b96814452", parameter_name = "privateDnsZoneId" },
    # --- Azure Event Grid Topics --- (privatelink.eventgrid.azure.net)
    { definition_name = "baf19753-7502-405f-8745-370519b20483", parameter_name = "privateDnsZoneId" },
    # --- Azure Disk Access --- (privatelink.blob.core.windows.net) -> Targets ACTIVE zone
    { definition_name = "bc05b96c-0b36-4ca9-82f0-5c53f96ce05a", parameter_name = "privateDnsZoneId" },
    # --- Azure Cognitive Services --- (privatelink.cognitiveservices.azure.com)
    { definition_name = "c4bc6f10-cb41-49eb-b000-d5ab82e2a091", parameter_name = "privateDnsZoneId" },
    # --- Azure IoT Hubs --- (privatelink.azure-devices.net)
    { definition_name = "c99ce9c1-ced7-4c3e-aca0-10e69ce0cb02", parameter_name = "privateDnsZoneId" },
    # --- Azure Event Grid Domains --- (privatelink.eventgrid.azure.net)
    { definition_name = "d389df0a-e0d7-4607-833c-75a6fdac2c2d", parameter_name = "privateDnsZoneId" },
    # --- Azure Cache for Redis --- (privatelink.redis.cache.windows.net)
    { definition_name = "e016b22b-e0eb-436d-8fd7-160c4eaed6e2", parameter_name = "privateDnsZoneId" },
    # --- Azure Container Registry --- (privatelink.azurecr.io)
    { definition_name = "e9585a95-5b8c-4d03-b193-dc7eb5ac4c32", parameter_name = "privateDnsZoneId" },
    # --- Azure Event Hub Namespace --- (privatelink.servicebus.windows.net)
    { definition_name = "ed66d4f5-8220-45dc-ab4a-20d1749c74e6", parameter_name = "privateDnsZoneId" },
    # --- Azure Machine Learning Workspace --- (privatelink.api.azureml.ms & privatelink.notebooks.azure.net)
    { definition_name = "ee40564d-486e-4f68-a5ca-7a621edae0fb", parameter_name = "privateDnsZoneId" },
    { definition_name = "ee40564d-486e-4f68-a5ca-7a621edae0fb", parameter_name = "secondPrivateDnsZoneId" },
    # --- Azure Service Bus Namespace --- (privatelink.servicebus.windows.net)
    { definition_name = "f0fcf93c-c063-4071-9668-c47474bd3564", parameter_name = "privateDnsZoneId" },
    # --- Azure Cognitive Search --- (privatelink.search.windows.net)
    { definition_name = "fbc14a67-53e4-4932-abcc-2049c6706009", parameter_name = "privateDnsZoneId" },
    # --- Azure Bot Service --- (privatelink.directline.botframework.com)
    { definition_name = "6a4e6f44-f2af-4082-9702-033c9e88b9f8", parameter_name = "privateDnsZoneId" },
    # --- Azure Managed Grafana --- (privatelink.grafana.azure.com)
    { definition_name = "4c8537f8-cd1b-49ec-b704-18e82a42fd58", parameter_name = "privateDnsZoneId" },
    # --- Azure Virtual Desktop --- (privatelink.wvd.microsoft.com)
    { definition_name = "9427df23-0f42-4e1e-bf99-a6133d841c4a", parameter_name = "privateDnsZoneId" }, # Hostpool
    { definition_name = "34804460-d88b-4922-a7ca-537165e060ed", parameter_name = "privateDnsZoneId" }, # Workspace
    # --- Azure IoT Device Update --- (privatelink.azure-devices.net)
    { definition_name = "a222b93a-e6c2-4c01-817f-21e092455b2a", parameter_name = "privateDnsZoneId" },
    # --- Azure Arc --- (Multiple zones)
    { definition_name = "55c4db33-97b0-437b-8469-c4f4498f5df9", parameter_name = "privateDnsZoneIDForGuestConfiguration" },
    { definition_name = "55c4db33-97b0-437b-8469-c4f4498f5df9", parameter_name = "privateDnsZoneIDForHybridResourceProvider" },
    { definition_name = "55c4db33-97b0-437b-8469-c4f4498f5df9", parameter_name = "privateDnsZoneIDForKubernetesConfiguration" },
    # --- Azure IoT Central --- (privatelink.azureiotcentral.com)
    { definition_name = "d627d7c6-ded5-481a-8f2e-7e16b1e6faf6", parameter_name = "privateDnsZoneId" },
    # --- Azure Storage Table --- (privatelink.table.core.windows.net)
    { definition_name = "028bbd88-e9b5-461f-9424-a1b63a7bee1a", parameter_name = "privateDnsZoneId" }, # Primary Table
    { definition_name = "c1d634a5-f73d-4cdd-889f-2cc7006eb47f", parameter_name = "privateDnsZoneId" }, # Secondary Table
    # --- Azure Site Recovery Backup --- (Multi-zone: backup, blob, queue) (Backup zone + targets other active zones)
    { definition_name = "af783da1-4ad1-42be-800d-d19c70038820", parameter_name = "privateDnsZone-Backup" },
    { definition_name = "af783da1-4ad1-42be-800d-d19c70038820", parameter_name = "privateDnsZone-Blob" },
    { definition_name = "af783da1-4ad1-42be-800d-d19c70038820", parameter_name = "privateDnsZone-Queue" },
  ]

  /*
  # Example of how to add management group role assignments
  management_group_role_assignments = {
    root_owner_role_assignment = {
      management_group_name      = "root"
      role_definition_id_or_name = "Owner"
      principal_id               = "00000000-0000-0000-0000-000000000000"
    }
  }
  */
}