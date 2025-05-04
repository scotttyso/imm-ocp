#_________________________________________________________________________________________
#
# Data Model Merge Process - Merge YAML Files into HCL Format
#_________________________________________________________________________________________
data "utils_yaml_merge" "model" {
  input = concat(
    [for file in fileset(path.module, "*.ezi.yaml") : file(file)],
    [for file in fileset(path.module, "p*/*.ezi.yaml") : file(file)],
    [for file in fileset(path.module, "t*/*.ezi.yaml") : file(file)]
  )
  merge_list_items = false
}

#_________________________________________________________________________________________
#
# Intersight:Organizations
# GUI Location: Settings > Organizations/Resource Groups
#_________________________________________________________________________________________
module "organizations" {
  # source = "/home/tyscott/terraform-cisco-modules/terraform-intersight-organizations"
  source          = "terraform-cisco-modules/organizations/intersight"
  version         = "4.2.11-20250410042505150"
  for_each        = { for i in ["map"] : i => i if length([setsubtract(keys(local.model), local.non_orgs)]) > 0 }
  global_settings = local.global_settings
  model           = { for k, v in local.model : k => v if length(regexall("^global_settings|intersight$", k)) == 0 }
}

#_________________________________________________________________________________________
#
# Intersight:Pools
# GUI Location: Infrastructure Service > Configure > Pools
#_________________________________________________________________________________________
module "pools" {
  # source = "/home/tyscott/terraform-cisco-modules/terraform-intersight-pools"
  source  = "terraform-cisco-modules/pools/intersight"
  version = "4.2.11-20250410042505150"
  for_each = {
    for i in ["map"] : i => i if length(flatten([for org in setsubtract(keys(local.model), local.non_orgs) : [
      for e in keys(lookup(local.model[org], "pools", {})) : e]])) > 0 || length(flatten([
      for org in setsubtract(keys(local.model), local.non_orgs) : [
        for e in lookup(lookup(local.model[org], "policies", {}), "server_pool_qualification", []) : e
      ]])) > 0 || length(
      flatten([for org in setsubtract(keys(local.model), local.non_orgs) : [for e in lookup(lookup(local.model[org], "profiles", {}), "server", []) : [
        for d in e["targets"] : lookup(d, "reservations", [])
      ]]])
    ) > 0
  }
  global_settings = local.global_settings
  model           = { for k, v in local.model : k => v if length(regexall("^global_settings|intersight$", k)) == 0 }
  orgs            = module.organizations["map"].organizations
}

#_________________________________________________________________________________________
#
# Intersight:Policies
# GUI Location: Infrastructure Service > Configure > Policies
#_________________________________________________________________________________________
module "policies" {
  source = "/home/tyscott/terraform-cisco-modules/terraform-intersight-policies"
  # source  = "terraform-cisco-modules/policies/intersight"
  # version = "4.2.11-20250410042505150"
  for_each = {
    for i in ["map"] : i => i if length(flatten([for org in keys(local.model) : [
      for e in setsubtract(keys(lookup(local.model[org], "policies", {})), ["server_pool_qualification"]
      ) : local.model[org].policies[e] if length(lookup(lookup(local.model[org], "policies", {}), e, [])) > 0]])
    ) > 0
  }
  global_settings    = local.global_settings
  model              = { for k, v in local.model : k => v if length(regexall("^global_settings|intersight$", k)) == 0 }
  orgs               = module.organizations["map"].organizations
  policies_sensitive = local.policies_sensitive
  pools              = module.pools
}

#_________________________________________________________________________________________
#
# Intersight: UCS Chassis, Domain, and Server Profiles/Templates
# GUI Location: Infrastructure Service > Configure > Profiles
# GUI Location: Infrastructure Service > Configure > Templates
#_________________________________________________________________________________________
module "profiles" {
  # source = "/home/tyscott/terraform-cisco-modules/terraform-intersight-profiles"
  source  = "terraform-cisco-modules/profiles/intersight"
  version = "4.2.11-20250410042505150"
  for_each = {
    for i in ["map"] : i => i if length(flatten([for org in keys(local.model) : [for e in ["profiles", "templates"] : [
      for d in ["chassis", "domain", "server"] : lookup(lookup(local.model[org], e, {}), d, [])]]]
    )) > 0
  }
  global_settings = local.global_settings
  model           = { for k, v in local.model : k => v if length(regexall("^global_settings|intersight$", k)) == 0 }
  orgs            = module.organizations["map"].organizations
  policies        = module.policies
  pools           = module.pools
}
