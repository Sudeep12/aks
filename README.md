<!-- BEGIN_TF_DOCS -->
# Azure Kubernetes Service (AKS) solution pattern [GOVI0001950](https://lseg.service-now.com/x/lsegp/cto/record/x_lsegp_eag_governance_item/0734dd1983fcc6503408b1c8beaad361)

Azure-prdsvcpat-terraform-aks-private is a terraform module which enables Azure Kubernetes Service in LSEG.

## Documentation

Detailed documentation is available on the project [website](https://ci.pages.dx1.lseg.com/containers/website/projects/aks/about/overview/).

## Support

For incidents requests, features or enhancements check [Cloud SRE support](https://lsegroup.sharepoint.com/sites/CloudCentral/SitePages/LMP-SRE-Incident-&-Request-Mgmt.aspx)

Details: https://lseg.stackenterprise.co/articles/23298

## Terraform docs

The terraform documentation in README.md file is auto-generated using terraform-docs. Please review the header.md file in-case there are any changes to be added in README.md

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | ~> 2.6.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 3.4 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.3 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | ~> 2.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.37 |
| <a name="requirement_local"></a> [local](#requirement\_local) | 2.5.3 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.2.4 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~> 0.13.1 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 4.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.3 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 3.0 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | ~> 2.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.37 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.5.3 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.4 |
| <a name="provider_time"></a> [time](#provider\_time) | ~> 0.13.1 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | ~> 4.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_add_group_rbac1"></a> [add\_group\_rbac1](#module\_add\_group\_rbac1) | git::https://gitlab.dx1.lseg.com/app/app-51310/azure/prdsvc/terraform/azure-prdsvc-terraform-roleassignment | 0.2.2 |
| <a name="module_agentpool_msi_rbac1"></a> [agentpool\_msi\_rbac1](#module\_agentpool\_msi\_rbac1) | git::https://gitlab.dx1.lseg.com/app/app-51310/azure/prdsvc/terraform/azure-prdsvc-terraform-roleassignment | 0.2.2 |
| <a name="module_azure-prdsvc-terraform-aks-cluster"></a> [azure-prdsvc-terraform-aks-cluster](#module\_azure-prdsvc-terraform-aks-cluster) | git::https://gitlab.dx1.lseg.com/app/app-51310/azure/prdsvc/terraform/azure-prdsvc-terraform-kubernetescluster | 2.0.0 |
| <a name="module_azure-prdsvc-terraform-aks-cluster-additional-pool"></a> [azure-prdsvc-terraform-aks-cluster-additional-pool](#module\_azure-prdsvc-terraform-aks-cluster-additional-pool) | git::https://gitlab.dx1.lseg.com/app/app-51310/azure/prdsvc/terraform/azure-prdsvc-terraform-kubernetesclusternodepool | 1.0.0 |
| <a name="module_azure-prdsvc-terraform-containerregistry"></a> [azure-prdsvc-terraform-containerregistry](#module\_azure-prdsvc-terraform-containerregistry) | git::https://gitlab.dx1.lseg.com/app/app-51310/azure/prdsvc/terraform/azure-prdsvc-terraform-containerregistry | 1.0.0 |
| <a name="module_azure-prdsvc-terraform-keyvaultkey-kms"></a> [azure-prdsvc-terraform-keyvaultkey-kms](#module\_azure-prdsvc-terraform-keyvaultkey-kms) | git::https://gitlab.dx1.lseg.com/app/app-51310/azure/prdsvc/terraform/azure-prdsvc-terraform-keyvaultkey | 0.3.0 |
| <a name="module_azure-prdsvc-terraform-nsg"></a> [azure-prdsvc-terraform-nsg](#module\_azure-prdsvc-terraform-nsg) | git::https://gitlab.dx1.lseg.com/app/app-51310/azure/prdsvc/terraform/azure-prdsvc-terraform-networksecuritygroup | 0.6.0 |
| <a name="module_azure-prdsvc-terraform-privateendpoint-acr"></a> [azure-prdsvc-terraform-privateendpoint-acr](#module\_azure-prdsvc-terraform-privateendpoint-acr) | git::https://gitlab.dx1.lseg.com/app/app-51310/azure/prdsvc/terraform/azure-prdsvc-terraform-privateendpoint | 0.7.0 |
| <a name="module_azure-prdsvc-terraform-routetable"></a> [azure-prdsvc-terraform-routetable](#module\_azure-prdsvc-terraform-routetable) | git::https://gitlab.dx1.lseg.com/app/app-51310/azure/prdsvc/terraform/azure-prdsvc-terraform-routetable | 1.0.1 |
| <a name="module_azure-prdsvc-terraform-subnet-aks"></a> [azure-prdsvc-terraform-subnet-aks](#module\_azure-prdsvc-terraform-subnet-aks) | git::https://gitlab.dx1.lseg.com/app/app-51310/azure/prdsvc/terraform/azure-prdsvc-terraform-subnet | 0.8.3 |
| <a name="module_azure-prdsvc-terraform-userassignedidentity"></a> [azure-prdsvc-terraform-userassignedidentity](#module\_azure-prdsvc-terraform-userassignedidentity) | git::https://gitlab.dx1.lseg.com/app/app-51310/azure/prdsvc/terraform/azure-prdsvc-terraform-userassignedidentity | 0.3.1 |
| <a name="module_msi_rbac"></a> [msi\_rbac](#module\_msi\_rbac) | git::https://gitlab.dx1.lseg.com/app/app-51310/azure/prdsvc/terraform/azure-prdsvc-terraform-roleassignment | 0.2.2 |
| <a name="module_spn_rbac1"></a> [spn\_rbac1](#module\_spn\_rbac1) | git::https://gitlab.dx1.lseg.com/app/app-51310/azure/prdsvc/terraform/azure-prdsvc-terraform-roleassignment | 0.2.2 |
| <a name="module_spn_rbac_acr"></a> [spn\_rbac\_acr](#module\_spn\_rbac\_acr) | git::https://gitlab.dx1.lseg.com/app/app-51310/azure/prdsvc/terraform/azure-prdsvc-terraform-roleassignment | 0.2.2 |
| <a name="module_user_assign_identity_rbac1"></a> [user\_assign\_identity\_rbac1](#module\_user\_assign\_identity\_rbac1) | git::https://gitlab.dx1.lseg.com/app/app-51310/azure/prdsvc/terraform/azure-prdsvc-terraform-roleassignment | 0.2.3 |
| <a name="module_user_assign_identity_rbac2"></a> [user\_assign\_identity\_rbac2](#module\_user\_assign\_identity\_rbac2) | git::https://gitlab.dx1.lseg.com/app/app-51310/azure/prdsvc/terraform/azure-prdsvc-terraform-roleassignment | 0.2.2 |

## Resources

| Name | Type |
|------|------|
| [azurerm_disk_encryption_set.des](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/disk_encryption_set) | resource |
| [azurerm_key_vault_key.kek](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_key_vault_key.kek1](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_private_dns_zone_virtual_network_link.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [helm_release.flux_operator](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.flux](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.kustomization_infra_common](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.kustomization_istio](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.kustomization_keda](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.kustomization_namespaces](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.kustomization_nginx](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.source_infra_common](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.source_infra_helm](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubernetes_config_map.flux-cluster-config](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_secret.flux-helm-secrets](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.gitlabtoken](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [null_resource.d9_get_cluster_id](https://registry.terraform.io/providers/hashicorp/null/3.2.4/docs/resources/resource) | resource |
| [time_sleep.flux_crds](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [time_sleep.wait_for_rbac_sync](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [time_sleep.wait_for_rbac_sync_des](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [tls_private_key.eus_ssh](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [azurerm_client_config.spn](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_firewall.afw](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/firewall) | data source |
| [azurerm_subscription.sub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [local_file.cluster-id](https://registry.terraform.io/providers/hashicorp/local/2.5.3/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acr"></a> [acr](#input\_acr) | Azure container registry values. Check example in .test/deployTest folder for more details | <pre>object({<br/>    instance                 = string<br/>    sku_tier                 = string<br/>    retention_policy_in_days = string<br/>    identity_type            = optional(string, "SystemAssigned")<br/>    georeplications          = any<br/>    encryption               = optional(bool, true)<br/>    network_rule_set         = optional(any, null)<br/>    trust_policy_enabled     = optional(bool, false)<br/>    zone_redundancy_enabled  = bool<br/>    data_endpoint_enabled    = bool<br/>    tags                     = optional(any, null)<br/>    pe_static_ip_required    = optional(bool, false)<br/>    pe_ip_configuration      = any<br/>  })</pre> | `null` | no |
| <a name="input_acr_encryption_enable"></a> [acr\_encryption\_enable](#input\_acr\_encryption\_enable) | Enable encryption for ACR | `bool` | `false` | no |
| <a name="input_add_group"></a> [add\_group](#input\_add\_group) | Azure AD groups that should have Read access to AKS cluster | `any` | `null` | no |
| <a name="input_additional_network_security_rules"></a> [additional\_network\_security\_rules](#input\_additional\_network\_security\_rules) | Network security Rules | <pre>map(object({<br/>    name                                       = string<br/>    description                                = optional(string)<br/>    protocol                                   = string<br/>    source_port_range                          = optional(string)<br/>    source_port_ranges                         = optional(list(string))<br/>    destination_port_range                     = optional(string)<br/>    destination_port_ranges                    = optional(list(string))<br/>    source_address_prefix                      = optional(string)<br/>    source_address_prefixes                    = optional(list(string))<br/>    source_application_security_group_ids      = optional(list(string))<br/>    destination_address_prefix                 = optional(string)<br/>    destination_address_prefixes               = optional(list(string))<br/>    destination_application_security_group_ids = optional(list(string))<br/>    access                                     = string<br/>    priority                                   = number<br/>    direction                                  = string<br/>  }))</pre> | `null` | no |
| <a name="input_additional_nodepool"></a> [additional\_nodepool](#input\_additional\_nodepool) | AKS user node pool map | <pre>map(object({<br/>    node_pool_name                    = string<br/>    node_pool_vm_size                 = string<br/>    node_pool_os_disk_size_gb         = number<br/>    node_pool_os_disk_type            = optional(string, "Managed")<br/>    node_pool_mode                    = optional(string, "User")<br/>    node_pool_os_type                 = optional(string, "Linux")<br/>    node_pool_node_labels             = map(string)<br/>    node_pool_node_count              = number<br/>    node_pool_auto_scaling_enabled    = bool<br/>    node_pool_min_count               = number<br/>    node_pool_max_count               = number<br/>    node_pool_max_pods                = number<br/>    node_pool_custom_ca_trust_enabled = optional(bool, false)<br/>    node_pool_host_encryption_enabled = optional(bool, true)<br/>    node_pool_host_group_id           = optional(string, null)<br/>    node_pool_node_public_ip_enabled  = optional(bool, false)<br/>    node_pool_fips_enabled            = optional(bool, false)<br/>    node_pool_priority                = optional(string, "Regular")<br/>    eviction_policy                   = optional(string, "Delete")<br/>    node_pool_spot_max_price          = number<br/>    node_pool_node_taints             = any<br/>    node_pool_zones                   = optional(list(number), ["1", "2", "3"])<br/>    kubernetes_version                = optional(string)<br/>    user_node_pool_linux_os_config    = optional(any, null)<br/><br/>  }))</pre> | `{}` | no |
| <a name="input_aks"></a> [aks](#input\_aks) | Azure Kubernetes Service Configuration. Check example in .test/deployTest folder for more details | <pre>object({<br/>    automatic_upgrade_channel                      = optional(string, null)<br/>    node_os_upgrade_channel                        = optional(string, "None")<br/>    enable_disk_encryption_aks                     = optional(string)<br/>    kubernetes_version                             = string<br/>    private_public_fqdn_enabled                    = optional(bool, false)<br/>    sku_tier                                       = optional(string, "Standard")<br/>    support_plan                                   = optional(string, "KubernetesOfficial")<br/>    workload_autoscaler_profile                    = map(string)<br/>    default_node_pool_name                         = optional(string, "default")<br/>    default_node_pool_node_count                   = optional(number, null)<br/>    default_node_pool_vm_size                      = optional(string, "Standard_D2s_v5")<br/>    default_node_pool_auto_scaling_enabled         = optional(bool, true)<br/>    default_node_pool_host_encryption_enabled      = optional(bool, true)<br/>    default_node_pool_node_public_ip_enabled       = optional(bool, false)<br/>    default_node_pool_fips_enabled                 = optional(bool, false)<br/>    default_node_pool_kubelet_disk_type            = optional(string, "OS")<br/>    default_node_pool_host_group_id                = optional(string, null)<br/>    default_node_pool_max_pods                     = optional(number, 110)<br/>    default_node_pool_node_public_ip_prefix_id     = optional(string, null)<br/>    default_node_pool_node_labels                  = optional(any, null)<br/>    default_node_pool_only_critical_addons_enabled = optional(bool, null)<br/>    default_node_pool_orchestrator_version         = optional(string)<br/>    default_node_pool_os_disk_size_gb              = optional(number, 128)<br/>    default_node_pool_os_disk_type                 = optional(string, "Managed")<br/>    default_node_pool_os_sku                       = optional(string, "Ubuntu")<br/>    default_node_pool_proximity_placement_group_id = optional(string, null)<br/>    default_node_pool_scale_down_mode              = optional(string, null)<br/>    default_node_pool_zones                        = optional(list(number), ["1", "2", "3"])<br/>    default_node_pool_ultra_ssd_enabled            = optional(bool, false)<br/>    default_node_pool_min_count                    = optional(number, 3)<br/>    default_node_pool_max_count                    = optional(number, 5)<br/>    default_node_pool_kubelet_config               = optional(any, null)<br/>    default_node_pool_linux_os_config              = optional(any, null)<br/>    default_node_pool_upgrade_settings             = optional(any, null)<br/>    key_management_service_keyvault_network_access = optional(string, "Private")<br/>    edge_zone                                      = optional(any, null)<br/>    auto_scaler_profile = optional(object({<br/>      balance_similar_node_groups      = optional(bool)<br/>      expander                         = optional(string, "random")<br/>      max_graceful_termination_sec     = optional(number)<br/>      max_node_provisioning_time       = optional(string)<br/>      max_unready_nodes                = optional(number)<br/>      max_unready_percentage           = optional(number)<br/>      new_pod_scale_up_delay           = optional(string)<br/>      scale_down_delay_after_add       = optional(string)<br/>      scale_down_delay_after_delete    = optional(string)<br/>      scale_down_delay_after_failure   = optional(string)<br/>      scan_interval                    = optional(string, "10s")<br/>      scale_down_unneeded              = optional(string)<br/>      scale_down_unready               = optional(string)<br/>      scale_down_utilization_threshold = optional(number)<br/>      empty_bulk_delete_max            = optional(number)<br/>      skip_nodes_with_local_storage    = optional(bool)<br/>      skip_nodes_with_system_pods      = optional(bool, true)<br/>    }))<br/>    key_vault_secrets_rotation_interval = optional(string, "2m")<br/>    maintenance_window                  = optional(any, null)<br/>    maintenance_window_auto_upgrade = optional(object({<br/>      frequency   = string<br/>      interval    = number<br/>      day_of_week = string<br/>      start_time  = string<br/>      utc_offset  = string<br/>      duration    = number<br/>      }), {<br/>      frequency   = "Weekly"<br/>      interval    = 1<br/>      day_of_week = "Friday"<br/>      start_time  = "00:00"<br/>      utc_offset  = "+00:00"<br/>      duration    = 4<br/>    })<br/>    maintenance_window_node_os = optional(object({<br/>      frequency   = string<br/>      interval    = number<br/>      day_of_week = string<br/>      start_time  = string<br/>      utc_offset  = string<br/>      duration    = number<br/>      }), {<br/>      frequency   = "Weekly"<br/>      interval    = 1<br/>      day_of_week = "Friday"<br/>      start_time  = "00:00"<br/>      utc_offset  = "+00:00"<br/>      duration    = 4<br/>    })<br/>    network_profile             = map(string)<br/>    service_principal           = optional(any, null)<br/>    monitor_metrics             = optional(any, null)<br/>    web_app_routing             = optional(any, null)<br/>    identity_type               = optional(string, "UserAssigned")<br/>    linux_profile_adminusername = string<br/>  })</pre> | n/a | yes |
| <a name="input_aks_subnet"></a> [aks\_subnet](#input\_aks\_subnet) | AKS subnet configuration | <pre>object({<br/>    address_prefixes                               = string<br/>    enforce_private_link_endpoint_network_policies = optional(string, "Disabled")<br/>    private_link_service_network_policies_enabled  = optional(bool, false)<br/>    enable_nsg_association                         = optional(bool, false)<br/>    instance                                       = string<br/>  })</pre> | n/a | yes |
| <a name="input_akv"></a> [akv](#input\_akv) | Azure keyvault configuration values | <pre>object({<br/>    expiration_date = optional(string, null)<br/>    rotation_policy = optional(map(string), {<br/>      expire_after         = "P365D"<br/>      notify_before_expiry = "P351D"<br/>      time_before_expiry   = null<br/>      time_after_creation  = "P358D"<br/>    })<br/>    key_opts = optional(list(string), ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"])<br/>  })</pre> | n/a | yes |
| <a name="input_akv_key_acr"></a> [akv\_key\_acr](#input\_akv\_key\_acr) | Azure Key Vault Key for ACR Configuration. Check example in .test/deployTest folder for more details | <pre>object({<br/>    key_name        = string<br/>    key_type        = optional(string, "RSA-HSM")<br/>    key_size        = optional(number, "2048")<br/>    expiration_date = optional(string, null)<br/>    rotation_policy = optional(map(string), {<br/>      expire_after         = "P365D"<br/>      notify_before_expiry = "P351D"<br/>      time_before_expiry   = null<br/>      time_after_creation  = "P358D"<br/>    })<br/>    key_opts = optional(list(string), ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"])<br/>  })</pre> | n/a | yes |
| <a name="input_akv_key_cmk"></a> [akv\_key\_cmk](#input\_akv\_key\_cmk) | Azure Key Vault Key for AKS CMK Configuration. Check example in .test/deployTest folder for more details | <pre>object({<br/>    key_name        = string<br/>    key_type        = optional(string, "RSA-HSM")<br/>    key_size        = optional(number, "2048")<br/>    expiration_date = optional(string, null)<br/>    rotation_policy = optional(map(string), {<br/>      expire_after         = "P365D"<br/>      notify_before_expiry = "P351D"<br/>      time_before_expiry   = null<br/>      time_after_creation  = "P358D"<br/>    })<br/>    key_opts = optional(list(string), ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"])<br/>  })</pre> | n/a | yes |
| <a name="input_app_id"></a> [app\_id](#input\_app\_id) | (Required) A descriptive name (abbreviation) for the workload (application) as it is registered in Leanix. The identifier format in Leanix is 'APP-12345', for the purpose of naming resources only 5 number will be used. | `string` | n/a | yes |
| <a name="input_app_resource_group_name"></a> [app\_resource\_group\_name](#input\_app\_resource\_group\_name) | Routable app resource group name | `string` | `null` | no |
| <a name="input_azure_firewall"></a> [azure\_firewall](#input\_azure\_firewall) | Define existing Azure firewall Name and Resource Group. Check example in .test/deployTest folder for more details | `map(string)` | `{}` | no |
| <a name="input_azure_key_vault_id"></a> [azure\_key\_vault\_id](#input\_azure\_key\_vault\_id) | ID for existing Key-Vault | `string` | n/a | yes |
| <a name="input_azurerm_disk_encryption_set"></a> [azurerm\_disk\_encryption\_set](#input\_azurerm\_disk\_encryption\_set) | Disk Encryption set configuration Values | <pre>object({<br/>    name                      = string<br/>    encryption_type           = string<br/>    auto_key_rotation_enabled = bool<br/>  })</pre> | n/a | yes |
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | SPN client ID. Fetched from DX1 vault | `string` | n/a | yes |
| <a name="input_client_secret"></a> [client\_secret](#input\_client\_secret) | SPN client Secret. Fetched from DX1 vault | `string` | n/a | yes |
| <a name="input_context"></a> [context](#input\_context) | (Optional) Application context information for the resource(s) (max 10 chars). | `string` | `null` | no |
| <a name="input_datadog_container_registry"></a> [datadog\_container\_registry](#input\_datadog\_container\_registry) | n/a | `string` | `"gcr.io"` | no |
| <a name="input_datadog_site"></a> [datadog\_site](#input\_datadog\_site) | n/a | `string` | `"datadoghq.eu"` | no |
| <a name="input_dd_api_key"></a> [dd\_api\_key](#input\_dd\_api\_key) | Datadog API key | `string` | n/a | yes |
| <a name="input_deploy_acr_and_privateendpoint"></a> [deploy\_acr\_and\_privateendpoint](#input\_deploy\_acr\_and\_privateendpoint) | Enable this to Deploy ACR and private endpoint for it | `bool` | `false` | no |
| <a name="input_deploy_additional_nodepool"></a> [deploy\_additional\_nodepool](#input\_deploy\_additional\_nodepool) | Deploy Additional User Node Pool | `bool` | `false` | no |
| <a name="input_deploy_istio"></a> [deploy\_istio](#input\_deploy\_istio) | Enable this setting to deploy Istio Service Mesh. Default is 'false' | `bool` | `false` | no |
| <a name="input_deploy_keda"></a> [deploy\_keda](#input\_deploy\_keda) | Enable this setting to deploy Keda. Default is 'false' | `bool` | `false` | no |
| <a name="input_deploy_nginx_ingress"></a> [deploy\_nginx\_ingress](#input\_deploy\_nginx\_ingress) | Enable this setting to deploy Nginx Ingress Controller. Default is 'false' | `bool` | `false` | no |
| <a name="input_deploy_private_dns_zone_vnet_link"></a> [deploy\_private\_dns\_zone\_vnet\_link](#input\_deploy\_private\_dns\_zone\_vnet\_link) | Deploy Virtual network link for Routable Vnet | `bool` | `false` | no |
| <a name="input_dome9_api_key"></a> [dome9\_api\_key](#input\_dome9\_api\_key) | Cloudguard/Dome9 API key | `string` | n/a | yes |
| <a name="input_dome9_api_secret"></a> [dome9\_api\_secret](#input\_dome9\_api\_secret) | Cloudguard/Dome9 API secret | `string` | n/a | yes |
| <a name="input_dx1_pat_token"></a> [dx1\_pat\_token](#input\_dx1\_pat\_token) | DX1 User Personal Access Token Value | `string` | n/a | yes |
| <a name="input_dx1_user"></a> [dx1\_user](#input\_dx1\_user) | DX1 User Personal Access Token Name | `string` | n/a | yes |
| <a name="input_enable_disk_encryption_aks"></a> [enable\_disk\_encryption\_aks](#input\_enable\_disk\_encryption\_aks) | Enable Disk Encryption for AKS | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (Required) The environment where the resource is deployed. Given as abbreviation to leave more characters to the other naming components (max 3 chars). | `string` | n/a | yes |
| <a name="input_falcon_cid"></a> [falcon\_cid](#input\_falcon\_cid) | Crowdstrike Agent CID | `string` | n/a | yes |
| <a name="input_falcon_docker_password"></a> [falcon\_docker\_password](#input\_falcon\_docker\_password) | Crowdstrike Docker registry password | `string` | n/a | yes |
| <a name="input_falcon_docker_username"></a> [falcon\_docker\_username](#input\_falcon\_docker\_username) | Crowdstrike Docker registry username | `string` | n/a | yes |
| <a name="input_falcon_token"></a> [falcon\_token](#input\_falcon\_token) | Crowdstrike falcon token | `string` | n/a | yes |
| <a name="input_flux_version"></a> [flux\_version](#input\_flux\_version) | (Optional) Version of the flux operator | `string` | `"2.x"` | no |
| <a name="input_gitops_aks_common_repo_reference"></a> [gitops\_aks\_common\_repo\_reference](#input\_gitops\_aks\_common\_repo\_reference) | GitOps common repo reference type, can be branch or tag | `string` | `"tag"` | no |
| <a name="input_gitops_aks_common_repo_version"></a> [gitops\_aks\_common\_repo\_version](#input\_gitops\_aks\_common\_repo\_version) | Always use tag revisions for all environments. | `string` | `""` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | (Optional) Instance number, if context includes/requires multiple resources of the same type (max 3 int). | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) Location of the resource group. | `string` | n/a | yes |
| <a name="input_nrt_vnet_id"></a> [nrt\_vnet\_id](#input\_nrt\_vnet\_id) | Non-Routable virtual Network ID | `string` | n/a | yes |
| <a name="input_org_id"></a> [org\_id](#input\_org\_id) | (Required) Three letter code representing organization/tenant/CSP. | `string` | n/a | yes |
| <a name="input_pe_subnet_id"></a> [pe\_subnet\_id](#input\_pe\_subnet\_id) | Subnet ID for use by Private Endpoints | `string` | n/a | yes |
| <a name="input_rt_vnet_id"></a> [rt\_vnet\_id](#input\_rt\_vnet\_id) | Routable virtual Network ID | `string` | n/a | yes |
| <a name="input_shared_vnet_name"></a> [shared\_vnet\_name](#input\_shared\_vnet\_name) | Non Routetable vnet name | `string` | `null` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Subscription ID where resources will be deployed | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) Tags to be set on each resource. | `map(any)` | `{}` | no |
| <a name="input_time_delay"></a> [time\_delay](#input\_time\_delay) | Added Time delay for RBAC sync | `string` | `"90s"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acr_resource"></a> [acr\_resource](#output\_acr\_resource) | Azure Container Registry Details |
| <a name="output_aks-cluster-additional-pool"></a> [aks-cluster-additional-pool](#output\_aks-cluster-additional-pool) | AKS cluster additional nodepool details |
| <a name="output_aks_id"></a> [aks\_id](#output\_aks\_id) | ID of the AKS Cluster |
| <a name="output_aks_managed_identity_resource"></a> [aks\_managed\_identity\_resource](#output\_aks\_managed\_identity\_resource) | User assigned Identity details |
| <a name="output_aks_name"></a> [aks\_name](#output\_aks\_name) | The name of the AKS Cluster |
| <a name="output_aks_resource"></a> [aks\_resource](#output\_aks\_resource) | Resource details of the AKS cluster |
| <a name="output_aks_rg_name"></a> [aks\_rg\_name](#output\_aks\_rg\_name) | AKS Cluster Resource Group Name |
| <a name="output_nsg"></a> [nsg](#output\_nsg) | Network Security Group Details |
| <a name="output_routetable"></a> [routetable](#output\_routetable) | Route Table details |
| <a name="output_subnet-aks"></a> [subnet-aks](#output\_subnet-aks) | AKS Subnet details |
<!-- END_TF_DOCS -->