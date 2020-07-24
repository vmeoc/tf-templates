provider "wavefront" {
  version = "~> 2.0"
  address = "vmware.wavefront.com"
  token   = var.myToken
}

resource "wavefront_alert" "test_alert_by_tf_from_vince" {
  name                   = "High CPU AlertV2"
  condition              = "100-ts(\"cpu.usage_idle\", environment=preprod and cpu=cpu-total ) > 80"
  additional_information = "This is an Alert"
  display_expression     = "100-ts(\"cpu.usage_idle\", environment=preprod and cpu=cpu-total )"
  minutes                = 5
  severity               = "WARN"
  tags = [
    "env.preprod",
    "cpu.total"
  ]
}
