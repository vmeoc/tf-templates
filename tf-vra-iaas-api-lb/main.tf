provider "vra" {
  url           = var.url
  refresh_token = var.refresh_token
  insecure      = true
}

data "vra_machine" "this" {
  id = var.vm_id
}

data "vra_network" "this" {
  name = var.network_name
  id = var.network_id
}

data "vra_project" "this" {
  name = var.project
}

resource "vra_load_balancer" "my_load_balancer" {
    name = "my-lb"
    project_id = data.vra_project.this.id
    description = "load balancer description"

    targets {
        machine_id = data.vra_machine.this.id
    }

    nics {
        network_id = data.vra_network.this.id
    }

    routes {
        protocol = "TCP"
        port = "80"
        member_protocol = "TCP"
        member_port = "80"
        health_check_configuration = {
            protocol = "TCP"
            port = "80"
            interval_seconds = 30
            timeout_seconds = 10
            unhealthy_threshold = 2
            healthy_threshold = 10
        }
    }
}
