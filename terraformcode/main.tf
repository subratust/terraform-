terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">=3.56.0"
    }
  }
}

provider "azurerm" {
  features {}
}
data "azurerm_subscription" "current" {
}

resource "azurerm_management_group" "root" {
  display_name = "DATAX"
    subscription_ids = [
  ]
}

resource "azurerm_management_group" "child" {
  display_name               = "Platform"
  parent_management_group_id = azurerm_management_group.root.id
  subscription_ids = [
  ]
}

resource "azurerm_management_group" "child_platform" {
  display_name               = "Management"
  parent_management_group_id = azurerm_management_group.child.id
  subscription_ids = [
  ]
}

#resource "azurerm_policy_definition" "policy" {
#  name         = "accTestPolicy"
#  policy_type  = "Custom"
#  mode         = "Indexed"
#display_name = "acceptance test policy definition"

resource "azurerm_policy_definition" "policy" {
  name                = "only-deploy-in-westeurope"
  display_name = "test"
  policy_type         = "Custom"
  mode                = "All"
  management_group_id = azurerm_management_group.root.id
  policy_rule = <<POLICY_RULE
    {
    "if": {
      "not": {
        "field": "location",
        "equals": "westeurope"
      }
    },
    "then": {
      "effect": "Deny"
    }
  }
POLICY_RULE
}

resource "azurerm_management_group_policy_assignment" "allowed_location" {
  name                 = "allowed-locations"
  policy_definition_id = azurerm_policy_definition.policy.id
  management_group_id  = azurerm_management_group.root.id
}
#resource "azurerm_policy_definition" "a" {
#  name         = "LinuxMechine"
#  mode         = "All"
#  display_name = "Audit Linux machines that have accounts without passwords"
#  description  = "This policy enables you to restrict the locations your organization can specify when deploying resources."
#  policy_type  = "BuiltIn"
#  policy_rule = <<POLICY_RULE
#    {
#  "properties": {
#    "displayName": "Audit Linux machines that have accounts without passwords",
#    "policyType": "BuiltIn",
#    "mode": "Indexed",
#    "description": "Requires that prerequisites are deployed to the policy assignment scope. For details, visit https://aka.ms/gcpol. Machines are non-compliant if Linux machines that have accounts without passwords",
#    "metadata": {
#      "category": "Guest Configuration",
#      "version": "3.0.0",
#      "requiredProviders": [
#        "Microsoft.GuestConfiguration"
#      ],
#      "guestConfiguration": {
#        "name": "PasswordPolicy_msid232",
#        "version": "1.*"
#      }
#    },
#    "parameters": {
#      "IncludeArcMachines": {
#        "type": "String",
#        "metadata": {
#          "displayName": "Include Arc connected servers",
#          "description": "By selecting this option, you agree to be charged monthly per Arc connected machine.",
#          "portalReview": "true"
#        },
#        "allowedValues": [
#          "true",
#          "false"
#        ],
#        "defaultValue": "false"
#      },
#      "effect": {
#        "type": "String",
#        "metadata": {
#          "displayName": "Effect",
#          "description": "Enable or disable the execution of this policy"
#        },
#        "allowedValues": [
#          "AuditIfNotExists",
#          "Disabled"
#        ],
#        "defaultValue": "AuditIfNotExists"
#      }
#    },
#    "policyRule": {
#      "if": {
#        "anyOf": [
#          {
#            "allOf": [
#              {
#                "field": "type",
#                "equals": "Microsoft.Compute/virtualMachines"
#              },
#              {
#                "anyOf": [
#                  {
#                    "field": "Microsoft.Compute/imagePublisher",
#                    "in": [
#                      "microsoft-aks",
#                      "qubole-inc",
#                      "datastax",
#                      "couchbase",
#                      "scalegrid",
#                      "checkpoint",
#                      "paloaltonetworks",
#                      "debian",
#                      "credativ"
#                    ]
#                  },
#                  {
#                    "allOf": [
#                      {
#                        "field": "Microsoft.Compute/imagePublisher",
#                        "equals": "OpenLogic"
#                      },
#                      {
#                        "field": "Microsoft.Compute/imageSKU",
#                        "notLike": "6*"
#                      }
#                    ]
#                  },
#                  {
#                    "allOf": [
#                      {
#                        "field": "Microsoft.Compute/imagePublisher",
#                        "equals": "Oracle"
#                      },
#                      {
#                        "field": "Microsoft.Compute/imageSKU",
#                        "notLike": "6*"
#                      }
#                    ]
#                  },
#                  {
#                    "allOf": [
#                      {
#                        "field": "Microsoft.Compute/imagePublisher",
#                        "equals": "RedHat"
#                      },
#                      {
#                        "field": "Microsoft.Compute/imageSKU",
#                        "notLike": "6*"
#                      }
#                    ]
#                  },
#                  {
#                    "allOf": [
#                      {
#                        "field": "Microsoft.Compute/imagePublisher",
#                        "equals": "center-for-internet-security-inc"
#                      },
#                      {
#                        "field": "Microsoft.Compute/imageOffer",
#                        "notLike": "cis-windows*"
#                      }
#                    ]
#                  },
#                  {
#                    "allOf": [
#                      {
#                        "field": "Microsoft.Compute/imagePublisher",
#                        "equals": "Suse"
#                      },
#                      {
#                        "field": "Microsoft.Compute/imageSKU",
#                        "notLike": "11*"
#                      }
#                    ]
#                  },
#                  {
#                    "allOf": [
#                      {
#                        "field": "Microsoft.Compute/imagePublisher",
#                        "equals": "Canonical"
#                      },
#                      {
#                        "field": "Microsoft.Compute/imageSKU",
#                        "notLike": "12*"
#                      }
#                    ]
#                  },
#                  {
#                    "allOf": [
#                      {
#                        "field": "Microsoft.Compute/imagePublisher",
#                        "equals": "microsoft-dsvm"
#                      },
#                      {
#                        "field": "Microsoft.Compute/imageOffer",
#                        "notLike": "dsvm-win*"
#                      }
#                    ]
#                  },
#                  {
#                    "allOf": [
#                      {
#                        "field": "Microsoft.Compute/imagePublisher",
#                        "equals": "cloudera"
#                      },
#                      {
#                        "field": "Microsoft.Compute/imageSKU",
#                        "notLike": "6*"
#                      }
#                    ]
#                  },
#                  {
#                    "allOf": [
#                      {
#                        "field": "Microsoft.Compute/imagePublisher",
#                        "equals": "microsoft-ads"
#                      },
#                      {
#                        "field": "Microsoft.Compute/imageOffer",
#                        "like": "linux*"
#                      }
#                    ]
#                  },
#                  {
#                    "allOf": [
#                      {
#                        "anyOf": [
#                          {
#                            "field": "Microsoft.Compute/virtualMachines/osProfile.linuxConfiguration",
#                            "exists": "true"
#                          },
#                          {
#                            "field": "Microsoft.Compute/virtualMachines/storageProfile.osDisk.osType",
#                            "like": "Linux*"
#                          }
#                        ]
#                      },
#                      {
#                        "anyOf": [
#                          {
#                            "field": "Microsoft.Compute/imagePublisher",
#                            "exists": "false"
#                          },
#                          {
#                            "field": "Microsoft.Compute/imagePublisher",
#                            "notIn": [
#                              "OpenLogic",
#                              "RedHat",
#                              "credativ",
#                              "Suse",
#                              "Canonical",
#                              "microsoft-dsvm",
#                              "cloudera",
#                              "microsoft-ads",
#                              "center-for-internet-security-inc",
#                              "Oracle",
#                              "AzureDatabricks",
#                              "azureopenshift"
#                            ]
#                          }
#                        ]
#                      }
#                    ]
#                  }
#                ]
#              }
#            ]
#          },
#          {
#            "allOf": [
#              {
#                "value": "[parameters('IncludeArcMachines')]",
#                "equals": "true"
#              },
#              {
#                "anyOf": [
#                  {
#                    "allOf": [
#                      {
#                        "field": "type",
#                        "equals": "Microsoft.HybridCompute/machines"
#                      },
#                      {
#                        "field": "Microsoft.HybridCompute/imageOffer",
#                        "like": "linux*"
#                      }
#                    ]
#                  },
#                  {
#                    "allOf": [
#                      {
#                        "field": "type",
#                        "equals": "Microsoft.ConnectedVMwarevSphere/virtualMachines"
#                      },
#                      {
#                        "field": "Microsoft.ConnectedVMwarevSphere/virtualMachines/osProfile.osType",
#                        "like": "linux*"
#                      }
#                    ]
#                  }
#                ]
#              }
#            ]
#          }
#        ]
#      },
#      "then": {
#        "effect": "[parameters('effect')]",
#        "details": {
#          "type": "Microsoft.GuestConfiguration/guestConfigurationAssignments",
#          "name": "PasswordPolicy_msid232",
#          "existenceCondition": {
#            "field": "Microsoft.GuestConfiguration/guestConfigurationAssignments/complianceStatus",
#            "equals": "Compliant"
#          }
#        }
#      }
#    }
#  },
#  "id": "/providers/Microsoft.Authorization/policyDefinitions/f6ec09a3-78bf-4f8f-99dc-6c77182d0f99",
#  "type": "Microsoft.Authorization/policyDefinitions",
#  "name": "f6ec09a3-78bf-4f8f-99dc-6c77182d0f99"
#}
#POLICY_RULE
#}
