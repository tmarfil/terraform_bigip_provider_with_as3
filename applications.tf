# A dedicated Terraform bigip_as3 resource per tenant.
# Each AS3 JSON declaration file is dedicated to a single tenant.
# Terraform resource "tenant_01" = Tenant_01 on the Big-IP
# Terraform resource "tenant_02: = Tenant_02 on the Big-IP
# ...and so on.
# Will not force updates during repeated "terraform apply" operations.

/*
resource "bigip_as3" "tenant_01" {
  as3_json = file("ordppdtest/random-decl-single-tenant1.json")
  # tenant_filter will ignore Tenants that are not a match.
  tenant_filter = "Tenant_01"
}

resource "bigip_as3" "tenant_02" {
  as3_json = file("ordppdtest/random-decl-single-tenant2.json")
  # tenant_filter will ignore Tenants that are not a match.
  tenant_filter = "Tenant_02"
}
*/

# Terraform "for_each" meta-argument will still create a bigip_as3 instance for each AS3 declaration,
# but now you can conveniently reference a directoy and add AS3 declarations without having to make changes to 
# Terraform configuration.
#
# Each AS3 JSON delcaration file is _still_ dedicated to a single tenant.
# Will not force updates during repeated "terraform apply" operations.

resource "bigip_as3" "for_each_all_tenants" {
    for_each = fileset(path.module, "ordppdtest/random-decl-single-tenant*.json")
    as3_json = "${file("${each.key}")}"
}