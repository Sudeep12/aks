#
# Copyright 2025 LSEG & Microsoft. All rights reserved.
#

######################################## Data sources #####################################################################################
# Azure Firewall
data "azurerm_firewall" "afw" {
  name                = var.azure_firewall.azure_firewall_name
  resource_group_name = var.azure_firewall.azure_firewall_rg_name
}

####################################################### User managed identity ########################################################################
#--------------------------------------------
# - Creating User assign Identity using module
# -------------------------------------------
module "azure-prdsvc-terraform-userassignedidentity" {
  #checkov:skip=CKV_TF_1:Skip module check for commit hash
  source              = "git::https://gitlab.dx1.lseg.com/app/app-51310/azure/prdsvc/terraform/azure-prdsvc-terraform-userassignedidentity?ref=0.3.1"
  org_id              = var.org_id
  app_id              = var.app_id
  location            = var.location
  environment         = var.environment
  context             = var.context
  instance            = var.instance
  resource_group_name = var.app_resource_group_name
}

locals {
  deploy_akv_key_for_kms = false ##Temporary until API server VNet injection becomes GA
}

# Assign permissions (decrypt and encrypt) to access key vault and Assign permission for creating private link
module "user_assign_identity_rbac1" {
  #checkov:skip=CKV_TF_1:Skip module check for commit hash
  count                = local.deploy_akv_key_for_kms == true ? 1 : 0
  source               = "git::https://gitlab.dx1.lseg.com/app/app-51310/azure/prdsvc/terraform/azure-prdsvc-terraform-roleassignment?ref=0.2.3"
  principal_id         = module.azure-prdsvc-terraform-userassignedidentity.principal_id
  role_definition_name = ["Key Vault Crypto User", "Key Vault Contributor"][count.index]
  scope                = var.azure_key_vault_id
  depends_on           = [module.azure-prdsvc-terraform-userassignedidentity]
}

# Assign permissions for a Network Contributor role on Platform vnet to create & manage load balancers
module "msi_rbac" {
  #checkov:skip=CKV_TF_1:Skip module check for commit hash
  source               = "git::https://gitlab.dx1.lseg.com/app/app-51310/azure/prdsvc/terraform/azure-prdsvc-terraform-roleassignment?ref=0.2.2"
  principal_id         = module.azure-prdsvc-terraform-userassignedidentity.principal_id
  role_definition_name = "Network Contributor"
  scope                = var.nrt_vnet_id
}

############################################################# NSG #####################################################################################
#------------------------------------------
# - Create a NSG
#------------------------------------------

locals {
  network_security_group_rules = {
    "rule1" = {
      name                                       = "rule1"
      description                                = "Rule for outbound"
      priority                                   = 110
      direction                                  = "Outbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    }
    "standard_routable_vnet_nsg_rule_1" = {
      name                                       = "AllowVnetInBound"
      description                                = "Inbound Allow VNet Traffic"
      priority                                   = 1000
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "VirtualNetwork"
      destination_address_prefix                 = "VirtualNetwork"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    }
    "standard_routable_vnet_nsg_rule_2" = {
      name                                       = "AzureLoadBalancer"
      description                                = "Inbound Allow LoadBalancer Traffic"
      priority                                   = 1010
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "AzureLoadBalancer"
      destination_address_prefix                 = "*"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = []
    }
  }
}

module "azure-prdsvc-terraform-nsg" {
  #checkov:skip=CKV_TF_1:Skip module check for commit hash
  source              = "git::https://gitlab.dx1.lseg.com/app/app-51310/azure/prdsvc/terraform/azure-prdsvc-terraform-networksecuritygroup?ref=0.6.0"
  org_id              = var.org_id
  app_id              = var.app_id
  location            = var.location
  environment         = var.environment
  context             = var.context
  instance            = var.instance
  resource_group_name = var.app_resource_group_name
  security_rules      = merge(local.network_security_group_rules, coalesce(var.additional_network_security_rules, {}))
  subnet_ids          = []
}

############################################################# Route table ##################################################################
locals {
  route_name = "${var.org_id}-${var.app_id}-${var.environment}-route-${var.context}-${substr(var.location, 0, 3)}"
}

module "azure-prdsvc-terraform-routetable" {
  #checkov:skip=CKV_TF_1:Skip module check for commit hash
  source = "git::https://gitlab.dx1.lseg.com/app/app-51310/azure/prdsvc/terraform/azure-prdsvc-terraform-routetable?ref=1.0.1"
  # Route table naming Variables
  org_id      = var.org_id
  app_id      = var.app_id
  location    = var.location
  environment = var.environment
  context     = var.context
  instance    = var.instance
  # Route table Setting
  resource_group_name           = var.app_resource_group_name
  bgp_route_propagation_enabled = false
  route = {
    "routekey1" = {
      name                   = "${local.route_name}-01"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = data.azurerm_firewall.afw.ip_configuration[0].private_ip_address
    },
    "routekey2" = {
      name                   = "${local.route_name}-02"
      address_prefix         = "10.0.0.0/8"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = data.azurerm_firewall.afw.ip_configuration[0].private_ip_address
    }
    "routekey3" = {
      name                   = "${local.route_name}-03"
      address_prefix         = "172.16.0.0/12"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = data.azurerm_firewall.afw.ip_configuration[0].private_ip_address
    }
  }
  subnet_ids = []
}

############################################################# Subnets ########################################################################
#---------------------------------------------
# Subnet module for aks - in Platform vnet
#---------------------------------------------

module "azure-prdsvc-terraform-subnet-aks" {
  source = "git::https://gitlab.dx1.lseg.com/app/app-51310/azure/prdsvc/terraform/azure-prdsvc-terraform-subnet?ref=0.8.3"
  #checkov:skip=CKV_TF_1:Skip module check for commit hash
  org_id                                         = var.org_id
  app_id                                         = var.app_id
  location                                       = var.location
  environment                                    = var.environment
  context                                        = var.context
  instance                                       = try(var.aks_subnet.instance, "01")
  virtual_network_id                             = var.nrt_vnet_id
  address_prefix                                 = var.aks_subnet.address_prefixes
  enforce_private_link_endpoint_network_policies = var.aks_subnet.enforce_private_link_endpoint_network_policies
  private_link_service_network_policies_enabled  = var.aks_subnet.private_link_service_network_policies_enabled
  service_endpoints                              = []
  route_table_id                                 = module.azure-prdsvc-terraform-routetable.id
  network_security_group_id                      = module.azure-prdsvc-terraform-nsg.id
  depends_on                                     = [module.azure-prdsvc-terraform-routetable]
}

############################################################# Azure Container Registry ##################################################################
#-------------------------------------
# - Creating Azure Container Registry
#-------------------------------------
module "azure-prdsvc-terraform-containerregistry" {
  #checkov:skip=CKV_TF_1:Skip module check for commit hash
  #checkov:skip=CKV_AZURE_163:Skip module check for commit hash
  #checkov:skip=CKV_AZURE_165:Skip module check for commit hash
  #checkov:skip=CKV_AZURE_167:Skip module check for commit hash
  #checkov:skip=CKV_AZURE_164:Skip module check for commit hash
  count  = var.deploy_acr_and_privateendpoint == true ? 1 : 0
  source = "git::https://gitlab.dx1.lseg.com/app/app-51310/azure/prdsvc/terraform/azure-prdsvc-terraform-containerregistry?ref=1.0.0"
  # container registry naming
  location    = var.location
  org_id      = var.org_id
  app_id      = var.app_id
  environment = var.environment
  context     = var.context
  instance    = var.instance
  # container registry settings
  resource_group_name      = var.app_resource_group_name
  sku_tier                 = var.acr.sku_tier
  retention_policy_in_days = var.acr.retention_policy_in_days
  identity = {
    type         = var.acr.identity_type
    identity_ids = [module.azure-prdsvc-terraform-userassignedidentity.id] #compatible only with "UserAssigned"
  }
  georeplications         = var.acr.georeplications
  network_rule_set        = var.acr.network_rule_set
  encryption              = var.acr_encryption_enable == true ? local.acr_encryption : null
  trust_policy_enabled    = var.acr.trust_policy_enabled
  zone_redundancy_enabled = var.acr.zone_redundancy_enabled
  data_endpoint_enabled   = var.acr.data_endpoint_enabled
  tags                    = var.acr.tags
  depends_on              = [module.azure-prdsvc-terraform-subnet-aks]
}

# ACR local

locals {
  acr_encryption = {
    enabled            = true
    key_vault_key_id   = try(azurerm_key_vault_key.kek1[0].versionless_id, null)
    identity_client_id = module.azure-prdsvc-terraform-userassignedidentity.client_id
  }
}

#----------------------------------
#   Private Endpoints module for ACR
#-----------------------------------
module "azure-prdsvc-terraform-privateendpoint-acr" {
  count = var.deploy_acr_and_privateendpoint == true ? 1 : 0
  #checkov:skip=CKV_TF_1:Skip module check for commit hash
  source                            = "git::https://gitlab.dx1.lseg.com/app/app-51310/azure/prdsvc/terraform/azure-prdsvc-terraform-privateendpoint?ref=0.7.0"
  resource_group_name               = var.app_resource_group_name
  org_id                            = var.org_id
  app_id                            = var.app_id
  location                          = var.location
  environment                       = var.environment
  context                           = var.context
  instance                          = var.acr.instance
  subnet_id                         = var.pe_subnet_id
  group_ids                         = ["registry"]
  is_manual_connection              = false
  private_connection_resource_id    = module.azure-prdsvc-terraform-containerregistry[0].id
  private_connection_resource_alias = null
  static_ip_required                = var.acr.pe_static_ip_required
  ip_configuration                  = var.acr.pe_ip_configuration
  tags                              = var.tags
}

# SPN need ARC push and pull permission
module "spn_rbac_acr" {
  #checkov:skip=CKV_TF_1:Skip module check for commit hash
  count                = var.deploy_acr_and_privateendpoint == true ? 1 : 0
  source               = "git::https://gitlab.dx1.lseg.com/app/app-51310/azure/prdsvc/terraform/azure-prdsvc-terraform-roleassignment?ref=0.2.2"
  principal_id         = data.azurerm_client_config.spn.object_id
  role_definition_name = ["AcrPush", "AcrPull"][count.index]
  scope                = module.azure-prdsvc-terraform-containerregistry[0].id
}

############################################################# Azure Key Vault ##################################################################

#-------------------------------------
# - Creating Key Vault Key for AKS KMS
#-------------------------------------
module "azure-prdsvc-terraform-keyvaultkey-kms" {
  #checkov:skip=CKV_AZURE_40:Skip module check for expiration date check on keys
  #checkov:skip=CKV_TF_1:Skip module check for commit hash
  count           = local.deploy_akv_key_for_kms == true ? 1 : 0
  source          = "git::https://gitlab.dx1.lseg.com/app/app-51310/azure/prdsvc/terraform/azure-prdsvc-terraform-keyvaultkey?ref=0.3.0"
  org_id          = var.org_id
  app_id          = var.app_id
  location        = var.location
  environment     = var.environment
  context         = var.context
  instance        = var.instance
  key_vault_id    = var.azure_key_vault_id
  expiration_date = var.akv.expiration_date
  rotation_policy = var.akv.rotation_policy
  key_opts        = var.akv.key_opts
}

############################################################# AKS cluster ##################################################################

#-------------------------------------------------------------------
# - Create AKS TSL provate key
#-------------------------------------------------------------------
##################################################### TLS PRIVATE KEY ###########################################

resource "tls_private_key" "eus_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#--------------------------------------------------
# - Generate the tag with pattern module version
#--------------------------------------------------
locals {
  # Product version tag
  svc_pattern_version = jsondecode(file("${path.module}/version.json"))
  tags                = merge(var.tags, local.svc_pattern_version)
}

#-------------------------------------------------------------------
# - Create AKS cluster
#-------------------------------------------------------------------

module "azure-prdsvc-terraform-aks-cluster" {
  #checkov:skip=CKV_TF_1:Skip module check for commit hash
  #checkov:skip=CKV_AZURE_168:Skip module check for commit hash
  #checkov:skip=CKV_AZURE_171:Skip module check for commit hash
  org_id      = var.org_id
  app_id      = var.app_id
  environment = var.environment
  context     = var.context
  instance    = var.instance
  depends_on = [
    module.user_assign_identity_rbac1,
    module.azure-prdsvc-terraform-userassignedidentity,
    module.msi_rbac
  ]
  source                                          = "git::https://gitlab.dx1.lseg.com/app/app-51310/azure/prdsvc/terraform/azure-prdsvc-terraform-kubernetescluster?ref=2.0.0"
  location                                        = var.location
  resource_group_name                             = var.app_resource_group_name
  automatic_upgrade_channel                       = var.aks.automatic_upgrade_channel
  node_os_upgrade_channel                         = var.aks.node_os_upgrade_channel
  disk_encryption_set_id                          = var.enable_disk_encryption_aks == true ? azurerm_disk_encryption_set.des[0].id : null
  kubernetes_version                              = var.aks.kubernetes_version
  private_cluster_public_fqdn_enabled             = var.aks.private_public_fqdn_enabled
  sku_tier                                        = var.aks.sku_tier
  support_plan                                    = var.aks.support_plan
  workload_autoscaler_profile                     = var.aks.workload_autoscaler_profile
  default_node_pool_name                          = var.aks.default_node_pool_name
  default_node_pool_node_count                    = var.aks.default_node_pool_node_count
  default_node_pool_vm_size                       = var.aks.default_node_pool_vm_size
  default_node_pool_capacity_reservation_group_id = var.aks.default_node_pool_capacity_reservation_group_id
  default_node_pool_auto_scaling_enabled          = var.aks.default_node_pool_auto_scaling_enabled
  default_node_pool_host_encryption_enabled       = var.aks.default_node_pool_host_encryption_enabled
  default_node_pool_node_public_ip_enabled        = var.aks.default_node_pool_node_public_ip_enabled
  default_node_pool_fips_enabled                  = var.aks.default_node_pool_fips_enabled
  default_node_pool_kubelet_disk_type             = var.aks.default_node_pool_kubelet_disk_type
  default_node_pool_host_group_id                 = var.aks.default_node_pool_host_group_id
  default_node_pool_max_pods                      = var.aks.default_node_pool_max_pods
  default_node_pool_node_public_ip_prefix_id      = var.aks.default_node_pool_node_public_ip_prefix_id
  default_node_pool_node_labels                   = var.aks.default_node_pool_node_labels
  default_node_pool_only_critical_addons_enabled  = var.aks.default_node_pool_only_critical_addons_enabled
  default_node_pool_orchestrator_version          = coalesce(var.aks.default_node_pool_orchestrator_version, var.aks.kubernetes_version)
  default_node_pool_os_disk_size_gb               = var.aks.default_node_pool_os_disk_size_gb
  default_node_pool_os_disk_type                  = var.aks.default_node_pool_os_disk_type
  default_node_pool_os_sku                        = var.aks.default_node_pool_os_sku
  default_node_pool_proximity_placement_group_id  = var.aks.default_node_pool_proximity_placement_group_id
  default_node_pool_scale_down_mode               = var.aks.default_node_pool_scale_down_mode
  default_node_pool_zones                         = var.aks.default_node_pool_zones
  default_node_pool_type                          = "VirtualMachineScaleSets"
  default_node_pool_tags                          = var.tags
  default_node_pool_ultra_ssd_enabled             = var.aks.default_node_pool_ultra_ssd_enabled
  default_node_pool_vnet_subnet_id                = module.azure-prdsvc-terraform-subnet-aks.id
  default_node_pool_max_count                     = var.aks.default_node_pool_max_count
  default_node_pool_min_count                     = var.aks.default_node_pool_min_count
  default_node_pool_kubelet_config                = var.aks.default_node_pool_kubelet_config
  default_node_pool_linux_os_config               = var.aks.default_node_pool_linux_os_config
  default_node_pool_upgrade_settings              = var.aks.default_node_pool_upgrade_settings
  oms_agent                                       = null
  edge_zone                                       = var.aks.edge_zone
  auto_scaler_profile                             = var.aks.auto_scaler_profile
  key_vault_secrets_rotation_interval             = var.aks.key_vault_secrets_rotation_interval
  ingress_application_gateway                     = null
  identity = {
    type         = var.aks.identity_type
    identity_ids = [module.azure-prdsvc-terraform-userassignedidentity.id]
  }
  linux_profile = {
    admin_username = var.aks.linux_profile_adminusername
    ssh_key = {
      key_data = tls_private_key.eus_ssh.public_key_openssh
    }
  }
  maintenance_window              = var.aks.maintenance_window
  maintenance_window_auto_upgrade = var.aks.maintenance_window_auto_upgrade
  maintenance_window_node_os      = var.aks.maintenance_window_node_os
  network_profile                 = var.aks.network_profile
  service_principal               = var.aks.service_principal
  monitor_metrics                 = var.aks.monitor_metrics
  web_app_routing                 = var.aks.web_app_routing
  key_management_service          = local.deploy_akv_key_for_kms == true ? local.key_management_service : null
  storage_profile = {
    blob_driver_enabled = false
    disk_driver_enabled = true
    disk_driver_version = "v1"
    file_driver_enabled = true
  }
  tags = local.tags
}

# This is needed to attach ACR with AKS
module "agentpool_msi_rbac1" {
  #checkov:skip=CKV_TF_1:Skip module check for commit hash
  count                = var.deploy_acr_and_privateendpoint == true ? 1 : 0
  source               = "git::https://gitlab.dx1.lseg.com/app/app-51310/azure/prdsvc/terraform/azure-prdsvc-terraform-roleassignment?ref=0.2.2"
  principal_id         = module.azure-prdsvc-terraform-aks-cluster.resource.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  scope                = module.azure-prdsvc-terraform-containerregistry[0].id
}

# this local has been use to get the Private DNS zone for the AKS cluster.
locals {
  quique_id = element(split(".", module.azure-prdsvc-terraform-aks-cluster.private_fqdn), 1)
  # enable encryption at rest for your Kubernetes secrets in etcd using Azure Key Vault with the Key Management Service (KMS) plugin.
  key_management_service = {
    key_vault_key_id         = local.deploy_akv_key_for_kms == true ? module.azure-prdsvc-terraform-keyvaultkey-kms[0].id : null
    key_vault_network_access = var.aks.key_management_service_keyvault_network_access
  }
}

#-----------------------------------------------------------------------
# - Virtual Network Links between AKS Private DNS zone and Platform.
#-----------------------------------------------------------------------
resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  #checkov:skip=CKV_TF_1:Skip module check for commit hash
  count                 = var.deploy_private_dns_zone_vnet_link == true ? 1 : 0
  name                  = "routable-vnet-link"
  resource_group_name   = module.azure-prdsvc-terraform-aks-cluster.node_resource_group
  private_dns_zone_name = format("%s.%s.%s.%s", local.quique_id, "privatelink", var.location, "azmk8s.io")
  virtual_network_id    = var.rt_vnet_id
  registration_enabled  = false
  tags                  = var.tags
}

### Azure AD group role assignment on AKS
module "add_group_rbac1" {
  #checkov:skip=CKV_TF_1:Skip module check for commit hash
  for_each = var.add_group
  source   = "git::https://gitlab.dx1.lseg.com/app/app-51310/azure/prdsvc/terraform/azure-prdsvc-terraform-roleassignment?ref=0.2.2"
  # Role Assignment
  principal_id         = each.value
  role_definition_name = "Azure Kubernetes Service RBAC Reader"
  scope                = module.azure-prdsvc-terraform-aks-cluster.id
}

### SPN role assignment on AKS

data "azurerm_client_config" "spn" {}

module "spn_rbac1" {
  #checkov:skip=CKV_TF_1:Skip module check for commit hash
  source = "git::https://gitlab.dx1.lseg.com/app/app-51310/azure/prdsvc/terraform/azure-prdsvc-terraform-roleassignment?ref=0.2.2"
  # Role Assignment
  principal_id         = data.azurerm_client_config.spn.object_id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  scope                = module.azure-prdsvc-terraform-aks-cluster.id
}

######################################### Additional Node pool ############################################################################################
#-------------------------------------------------------------------
# - Create AKS cluster additional node pool
#-------------------------------------------------------------------
module "azure-prdsvc-terraform-aks-cluster-additional-pool" {
  #checkov:skip=CKV_TF_1:Skip module check for commit hash
  #checkov:skip=CKV_AZURE_168:Skip module check for commit hash
  for_each = var.deploy_additional_nodepool == true ? var.additional_nodepool : {}

  source                                  = "git::https://gitlab.dx1.lseg.com/app/app-51310/azure/prdsvc/terraform/azure-prdsvc-terraform-kubernetesclusternodepool?ref=1.1.0"
  kubernetes_cluster_id                   = module.azure-prdsvc-terraform-aks-cluster.id
  node_pool_name                          = each.value.node_pool_name
  node_pool_vm_size                       = each.value.node_pool_vm_size
  node_pool_mode                          = each.value.node_pool_mode
  node_pool_os_disk_size_gb               = each.value.node_pool_os_disk_size_gb
  node_pool_os_disk_type                  = each.value.node_pool_os_disk_type
  node_pool_os_type                       = each.value.node_pool_os_type
  node_pool_node_labels                   = each.value.node_pool_node_labels
  node_pool_node_count                    = each.value.node_pool_node_count
  node_pool_auto_scaling_enabled          = each.value.node_pool_auto_scaling_enabled
  node_pool_min_count                     = each.value.node_pool_min_count
  node_pool_max_count                     = each.value.node_pool_max_count
  node_pool_max_pods                      = each.value.node_pool_max_pods
  node_pool_vnet_subnet_id                = module.azure-prdsvc-terraform-subnet-aks.id
  node_pool_host_encryption_enabled       = each.value.node_pool_host_encryption_enabled
  node_pool_host_group_id                 = each.value.node_pool_host_group_id
  node_pool_node_public_ip_enabled        = each.value.node_pool_node_public_ip_enabled
  node_pool_fips_enabled                  = each.value.node_pool_fips_enabled
  node_pool_priority                      = each.value.node_pool_priority
  eviction_policy                         = each.value.eviction_policy
  node_pool_spot_max_price                = each.value.node_pool_spot_max_price
  node_pool_node_taints                   = each.value.node_pool_node_taints
  node_pool_zones                         = each.value.node_pool_zones
  user_node_pool_linux_os_config          = each.value.user_node_pool_linux_os_config
  node_pool_capacity_reservation_group_id = each.value.node_pool_capacity_reservation_group_id
  tags                                    = var.tags
  kubernetes_version                      = coalesce(each.value.kubernetes_version, var.aks.kubernetes_version)
}

#-------------------------------------
# - Creating Key Vault Key for AKS CMK 
#-------------------------------------

resource "azurerm_key_vault_key" "kek" {
  #checkov:skip=CKV_TF_1:Skip module check for commit hash
  #checkov:skip=CKV_AZURE_40:Skip module check for expiration date check on keys
  count           = var.enable_disk_encryption_aks == true ? 1 : 0
  name            = var.akv_key_cmk.key_name
  key_vault_id    = var.azure_key_vault_id
  key_type        = var.akv_key_cmk.key_type
  key_size        = var.akv_key_cmk.key_size
  expiration_date = var.akv_key_cmk.expiration_date

  key_opts = var.akv_key_cmk.key_opts
  rotation_policy {
    automatic {
      time_before_expiry  = var.akv_key_cmk.rotation_policy.time_before_expiry
      time_after_creation = var.akv_key_cmk.rotation_policy.time_after_creation
    }
    expire_after         = var.akv_key_cmk.rotation_policy.expire_after
    notify_before_expiry = var.akv_key_cmk.rotation_policy.notify_before_expiry
  }
}

resource "azurerm_key_vault_key" "kek1" {
  #checkov:skip=CKV_TF_1:Skip module check for commit hash
  #checkov:skip=CKV_AZURE_40:Skip module check for expiration date check on keys
  count           = var.acr_encryption_enable == true ? 1 : 0
  name            = var.akv_key_acr.key_name
  key_vault_id    = var.azure_key_vault_id
  key_type        = var.akv_key_acr.key_type
  key_size        = var.akv_key_acr.key_size
  expiration_date = var.akv_key_acr.expiration_date

  key_opts = var.akv_key_acr.key_opts
  rotation_policy {
    automatic {
      time_before_expiry  = var.akv_key_acr.rotation_policy.time_before_expiry
      time_after_creation = var.akv_key_acr.rotation_policy.time_after_creation
    }
    expire_after         = var.akv_key_acr.rotation_policy.expire_after
    notify_before_expiry = var.akv_key_acr.rotation_policy.notify_before_expiry
  }
}

#----------------------------------------------------------------
# - Assign Key Vault Crypto Service Encryption User to des on KV
#----------------------------------------------------------------
module "user_assign_identity_rbac2" {
  count = var.enable_disk_encryption_aks == true ? 1 : 0
  #checkov:skip=CKV_TF_1:Skip module check for commit hash
  source = "git::https://gitlab.dx1.lseg.com/app/app-51310/azure/prdsvc/terraform/azure-prdsvc-terraform-roleassignment?ref=0.2.2"
  # Role Assignment
  principal_id         = module.azure-prdsvc-terraform-userassignedidentity.principal_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  scope                = var.azure_key_vault_id
}

#Adding a time delay for the rbac assignment to propagate before deploying aks tools and KV key and des creation
resource "time_sleep" "wait_for_rbac_sync_des" {
  depends_on       = [module.user_assign_identity_rbac2]
  create_duration  = var.time_delay
  destroy_duration = "1s"
}

#----------------------------------------------------------------
# - Create Disk encryption set
#----------------------------------------------------------------
resource "azurerm_disk_encryption_set" "des" {
  #checkov:skip=CKV_TF_1:Skip module check for commit hash
  count                     = var.enable_disk_encryption_aks == true ? 1 : 0
  name                      = var.azurerm_disk_encryption_set.name
  resource_group_name       = var.app_resource_group_name
  location                  = var.location
  key_vault_key_id          = azurerm_key_vault_key.kek[0].versionless_id
  encryption_type           = var.azurerm_disk_encryption_set.encryption_type
  auto_key_rotation_enabled = true
  identity {
    type         = "UserAssigned"
    identity_ids = [module.azure-prdsvc-terraform-userassignedidentity.id]
  }
  tags       = var.tags
  depends_on = [time_sleep.wait_for_rbac_sync_des]

  lifecycle {
    ignore_changes = [
      tags["mnd-applicationid"],
      tags["mnd-applicationname"],
      tags["mnd-costcentre"],
      tags["mnd-dataclassification"],
      tags["mnd-envsubtype"],
      tags["mnd-envtype"],
      tags["mnd-lifecycle"],
      tags["mnd-owner"],
      tags["mnd-projectcode"],
      tags["mnd-supportgroup"],
      tags["opt-cpf-product-deployment"]
    ]
  }
}

#Adding a time delay for the rbac assignment to propagate before deploying aks tools and KV key and des creation
resource "time_sleep" "wait_for_rbac_sync" {
  depends_on       = [module.spn_rbac1]
  create_duration  = var.time_delay
  destroy_duration = "1s"
}

data "azurerm_subscription" "sub" {
  subscription_id = var.subscription_id
}
