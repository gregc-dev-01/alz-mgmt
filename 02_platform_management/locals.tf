locals {
  management_groups_enabled    = try(var.management_group_settings.enabled, true)
  management_resources_enabled = try(var.management_resource_settings.enabled, true)
}

# Build policy dependencies
locals {
  management_group_dependencies = {
    policy_assignments = [module.management_resources]
    policy_role_assignments = [module.management_resources]
  }
}
