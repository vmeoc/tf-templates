terraform {
  required_providers {
    vra = {
      source = "vmware/vra"
#      version = "0.3.5"
    }
  }
}
provider vra {
  url           = var.url
  refresh_token = var.refresh_token
}

data "vra_catalog_item" "this" {
  name            = "CentOS"
  expand_versions = true
}

data "vra_project" "this" {
  name            = "Sandbox"
}

resource "vra_deployment" "tfdeploymentExample" {
  name        = "Terraform Deployment Example"
  description = "Deployed from vRA provider for Terraform."

  catalog_item_id      = data.vra_catalog_item.this.id
  project_id        = data.vra_project.this.id

  inputs = {
    VMSize = "medium"
    disknumber = 1
  }

  timeouts {
    create = "30m"
    delete = "30m"
    update = "30m"
  }

}
