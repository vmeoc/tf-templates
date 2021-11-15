provider "vra" {
  url           = var.url
  refresh_token = var.refresh_token
  insecure      = true
}

data "vra_cloud_account_vsphere" "this" {
  name = var.cloud_account
}

data "vra_project" "this" {
  name = var.project
}

data "vra_network" "this" {
  name = var.network_name
}

#resource "vra_block_device" "disk1" {
#  capacity_in_gb = 10
#  name = "terraform_vra_block_device1"
#  project_id = data.vra_project.this.id
#  constraints {
#    mandatory  = true
#    expression = "cpod:vrealize"
#  }

#}

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
  users:
  - default
  - name: myuser
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    groups: [wheel, sudo, admin]
    shell: '/bin/bash'
    ssh-authorized-keys: |
      ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDytVL+Q6/UmGwdnJxKQEozqERHGqxlH/zBbT5W8iNbwgOLF6JWz0o7ThAK/Cf0uPcv78Q6UhOjuRfd2BKBciJx5JsyH4Ly7Ars2v/ZQ492KyZElKRqwibXNWjfZcwKU/6YjDITm15Yh6UWCsvVHg4w72X+TiTxeKDZ0pNt2hcZ5Uje6NvZ4GFKYfl4kNFxBZmBYLFdtq8eNPg3PGREV+pM0xkyXKSAYUsXsgj821AgK/YNByCPY53jNKqXqdFKQXKG7FOs78MdhAF7aGMsVRymY5RtHk9UO0DGzCIHRp9DqmfN9SdIYIf5fb4sEtt8T9uxW32Mx3d9S+vGbmkYoRpY user@example.com

  runcmd:
    - sudo sed -e 's/.*PasswordAuthentication yes.*/PasswordAuthentication no/' -i /etc/ssh/sshd_config
    - sudo service sshd restart
EOF
  }

  nics {
    network_id = data.vra_network.this.id
    custom_properties = {
      ipAssignmentType = "static"
  }

  }

#  constraints {
#    mandatory  = true
#    expression = "cpod:cpod-vr"
#  }

  tags {
    key   = "foo"
    value = "bar"
  }

#  disks {
#    block_device_id = vra_block_device.disk1.id
#  }

  timeouts {
    create = "20m"
  }

}

