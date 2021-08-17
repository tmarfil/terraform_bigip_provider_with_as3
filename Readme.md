# Terraform BigIP Provider with AS3 Example

## Solution Summary

* One AS3 declaration per _Tenant_
* A single AS3 declaration can define many _Applications_

## Steps

1. Clone the rep and cd into the working directory.

```
git clone https://github.com/tmarfil/terraform_bigip_provider_with_as3_example.git
cd terraform_bigip_provider_with_as3_example
ls *.tf
```

2. Create a **terraform.tfvars** file. Provide the bigip_address, bigip_username, and bigip_password.

```
bigip_address  = "x.x.x.x"
bigip_username = "admin"
bigip_password = ""
```

3. Chose one of the two examples in **applications.tf** .

## Example 1

```
resource "bigip_as3" "tenant_01" {
  as3_json = file("ordppdtest/random-decl-single-tenant1.json")
  # tenant_filter will ignore Tenants that are not a match.
  tenant_filter = "Tenant_01"
  
}

resource "bigip_as3" "tenant_02" {
  as3_json = file("ordppdtest/random-decl-single-tenant2.json")
  # tenant_filter will ignore Tenants that are not a match.
  tenant_filter = "Tenant_0"
}
```

## Example 2

```
resource "bigip_as3" "for_each_all_tenants" {
    for_each = fileset(path.module, "ordppdtest/random-decl-single-tenant*.json")
    as3_json = "${file("${each.key}")}"
}
```
---
**NOTE**

The bigip_as3 resources refernce two AS3 declarations in the **ordppdtest** directoy.

---

**random-decl-single-tenant1.json**

````
{
  "class": "AS3",
  "action": "deploy",
  "persist": true,
  "declaration": {
    "class": "ADC",
    "schemaVersion": "3.29.0",
    "id": "random-decl1",
    "remark": "random-decl1",
    "Tenant_01": {
      "class": "Tenant",
      "random-decl1-app": {
        "class": "Application",
        "random-decl1_80_vs": {
          "class": "Service_HTTP",
          "virtualAddresses": ["1.1.12.44"],
          "profileMultiplex": {
            "bigip": "/Common/oneconnect"
          },
          "persistenceMethods": [
            {
              "bigip": "/Common/cookie"
            }
          ],
          "virtualPort": 80,
          "pool": "random-decl1_8080_pool",
          "profileTCP": {
            "bigip": "/Common/tcp"
          },
          "snat": "auto"
        },
        "random-decl1_8080_pool": {
          "class": "Pool",
          "monitors": ["http"],
          "members": [
            {
              "servicePort": 8080,
              "serverAddresses": ["2.2.12.43", "3.3.12.43"]
            }
          ]
        }
      },
      "random-decl2-app": {
        "class": "Application",
        "random-decl2_80_vs": {
          "class": "Service_HTTP",
          "virtualAddresses": ["1.1.11.53"],
          "profileMultiplex": {
            "bigip": "/Common/oneconnect"
          },
          "virtualPort": 80,
          "pool": "random-decl2_8080_pool",
          "profileTCP": {
            "bigip": "/Common/tcp"
          },
          "snat": "auto"
        },
        "random-decl2_8080_pool": {
          "class": "Pool",
          "monitors": ["http"],
          "members": [
            {
              "servicePort": 8080,
              "serverAddresses": ["2.2.11.51", "3.3.11.51"]
            }
          ]
        }
      }
    }
  }
}
```

**random-decl-single-tenant2.json**


```
{
  "class": "AS3",
  "action": "deploy",
  "persist": true,
  "declaration": {
    "class": "ADC",
    "schemaVersion": "3.29.0",
    "id": "random-decl1",
    "remark": "random-decl1",
    "Tenant_02": {
      "class": "Tenant",
      "random-decl1-app": {
        "class": "Application",
        "random-decl1_80_vs": {
          "class": "Service_HTTP",
          "virtualAddresses": ["1.1.12.244"],
          "profileMultiplex": {
            "bigip": "/Common/oneconnect"
          },
          "persistenceMethods": [
            {
              "bigip": "/Common/cookie"
            }
          ],
          "virtualPort": 80,
          "pool": "random-decl1_8080_pool",
          "profileTCP": {
            "bigip": "/Common/tcp"
          },
          "snat": "auto"
        },
        "random-decl1_8080_pool": {
          "class": "Pool",
          "monitors": ["http"],
          "members": [
            {
              "servicePort": 8080,
              "serverAddresses": ["2.2.12.243", "3.3.12.243"]
            }
          ]
        }
      },
      "random-decl2-app": {
        "class": "Application",
        "random-decl2_80_vs": {
          "class": "Service_HTTP",
          "virtualAddresses": ["1.1.11.253"],
          "profileMultiplex": {
            "bigip": "/Common/oneconnect"
          },
          "virtualPort": 80,
          "pool": "random-decl2_8080_pool",
          "profileTCP": {
            "bigip": "/Common/tcp"
          },
          "snat": "auto"
        },
        "random-decl2_8080_pool": {
          "class": "Pool",
          "monitors": ["http"],
          "members": [
            {
              "servicePort": 8080,
              "serverAddresses": ["2.2.11.251", "3.3.11.251"]
            }
          ]
        }
      }
    }
  }
}
```