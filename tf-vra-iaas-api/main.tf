provider "vra" {
  url           = var.url
  refresh_token = var.refresh_token
  insecure      = true
}


data "vra_project" "this" {
  name = var.project
}

data "vra_network" "this" {
  name = var.network_name
}


resource "random_id" "id" {
	  byte_length = 8
}

resource "vra_machine" "this" {
  name        = "tf-machine-${random_id.id.hex}"
  description = "terrafrom test machine"
  project_id  = data.vra_project.this.id
  image       = "CentosV7"
  flavor      = "small"
  custom_properties = {
    customizationSpec = "Linux"   
  }
  boot_config {
    content = <<EOF
#cloud-config
  runcmd:
    - yum install httpd -y
    - systemctl enable httpd
    - systemctl start httpd
    - echo V2 >> /var/www/html/index.html
EOF
  }

  nics {
    network_id = data.vra_network.this.id
    custom_properties = {
      ipAssignmentType = "static"
  }

  }


  tags {
    key   = "foo"
    value = "bar"
  }


  timeouts {
    create = "20m"
  }

}

output "machine_ip_addr" {
    value = vra_machine.this.address
}
