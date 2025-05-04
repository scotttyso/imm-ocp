locals {
  global_settings = {
    tags = lookup(local.model.global_settings, "tags", [
      {
        key   = "Module"
        value = "easy-imm"
      },
      {
        key   = "Version"
        value = "4.2.11-18370"
      }
    ])
  }
  intersight_fqdn = lookup(local.model.global_settings, "intersight_fqdn", "intersight.com")
  model           = yamldecode(data.utils_yaml_merge.model.output)
  non_orgs        = ["global_settings", "intersight"]

  #__________________________________________________________________
  #
  # Sensitive Variables
  #__________________________________________________________________
  policies_sensitive = {
    certificate_management = {
      certificate = {
        1 = fileexists(var.cert_mgmt_certificate_1) ? file(var.cert_mgmt_certificate_1) : var.cert_mgmt_certificate_1
        2 = fileexists(var.cert_mgmt_certificate_2) ? file(var.cert_mgmt_certificate_2) : var.cert_mgmt_certificate_2
        3 = fileexists(var.cert_mgmt_certificate_3) ? file(var.cert_mgmt_certificate_3) : var.cert_mgmt_certificate_3
        4 = fileexists(var.cert_mgmt_certificate_4) ? file(var.cert_mgmt_certificate_4) : var.cert_mgmt_certificate_4
        5 = fileexists(var.cert_mgmt_certificate_5) ? file(var.cert_mgmt_certificate_5) : var.cert_mgmt_certificate_5
      }
      private_key = {
        1 = fileexists(var.cert_mgmt_private_key_1) ? file(var.cert_mgmt_private_key_1) : var.cert_mgmt_private_key_1
        2 = fileexists(var.cert_mgmt_private_key_2) ? file(var.cert_mgmt_private_key_2) : var.cert_mgmt_private_key_2
        3 = fileexists(var.cert_mgmt_private_key_3) ? file(var.cert_mgmt_private_key_3) : var.cert_mgmt_private_key_3
        4 = fileexists(var.cert_mgmt_private_key_4) ? file(var.cert_mgmt_private_key_4) : var.cert_mgmt_private_key_4
        5 = fileexists(var.cert_mgmt_private_key_5) ? file(var.cert_mgmt_private_key_5) : var.cert_mgmt_private_key_5
      }
    }
    drive_security = {
      current_security_key_passphrase = {
        1 = var.drive_security_current_security_key_passphrase
      }
      new_security_key_passphrase = {
        1 = var.drive_security_new_security_key_passphrase
      }
      password = {
        1 = var.drive_security_authentication_password
      }
      server_public_root_ca_certificate = {
        1 = fileexists(var.drive_security_server_ca_certificate
        ) ? file(var.drive_security_server_ca_certificate) : var.drive_security_server_ca_certificate
      }
    }
    firmware = {
      cco_password = { 1 = var.cco_password }
      cco_user     = { 1 = var.cco_user }
    }
    ipmi_over_lan = { encryption_key = { 1 = var.ipmi_encryption_key } }
    iscsi_boot    = { password = { 1 = var.iscsi_boot_password } }
    ldap          = { password = { 1 = var.binding_parameters_password } }
    local_user = {
      password = {
        1 = var.local_user_password_1
        2 = var.local_user_password_2
        3 = var.local_user_password_3
        4 = var.local_user_password_4
        5 = var.local_user_password_5
      }
    }
    mac_sec = {
      fallback_key_chain = {
        1 = var.mac_sec_fallback_key_chain_secret_1
        2 = var.mac_sec_fallback_key_chain_secret_2
        3 = var.mac_sec_fallback_key_chain_secret_3
        4 = var.mac_sec_fallback_key_chain_secret_4
        5 = var.mac_sec_fallback_key_chain_secret_5
      }
      primary_key_chain = {
        1 = var.mac_sec_primary_key_chain_secret_1
        2 = var.mac_sec_primary_key_chain_secret_2
        3 = var.mac_sec_primary_key_chain_secret_3
        4 = var.mac_sec_primary_key_chain_secret_4
        5 = var.mac_sec_primary_key_chain_secret_5
      }
    }
    persistent_memory = { passphrase = { 1 = var.persistent_passphrase } }
    snmp = {
      access_community_string = {
        1 = var.access_community_string_1
        2 = var.access_community_string_2
        3 = var.access_community_string_3
        4 = var.access_community_string_4
        5 = var.access_community_string_5
      }
      auth_password = {
        1 = var.snmp_auth_password_1
        2 = var.snmp_auth_password_2
        3 = var.snmp_auth_password_3
        4 = var.snmp_auth_password_4
        5 = var.snmp_auth_password_5
      }
      privacy_password = {
        1 = var.snmp_privacy_password_1
        2 = var.snmp_privacy_password_2
        3 = var.snmp_privacy_password_3
        4 = var.snmp_privacy_password_4
        5 = var.snmp_privacy_password_5
      }
      trap_community_string = {
        1 = var.snmp_trap_community_1
        2 = var.snmp_trap_community_2
        3 = var.snmp_trap_community_3
        4 = var.snmp_trap_community_4
        5 = var.snmp_trap_community_5
      }
    }
    switch_control = { aes_primary_key = { 1 = var.switch_control_aes_primary_key_1 } }
    virtual_media = {
      password = {
        1 = var.vmedia_password_1
        2 = var.vmedia_password_2
        3 = var.vmedia_password_3
        4 = var.vmedia_password_4
        5 = var.vmedia_password_5
      }
    }
  }
}
