terraform {
  # Версия terraform
  required_version = "0.11.11"
}

provider "google" {
  # Версия провайдера
  version = "2.0.0"

  # ID проекта
  project = "${var.project}"
  region  = "${var.region}"
}

module "gce-ilb" {
  source         = "github.com/GoogleCloudPlatform/terraform-google-lb-internal"
  region         = "${var.region}"
  name           = "group2-ilb"
  ports          = ["${module.mig2.service_port}"]
  health_port    = "${module.mig2.service_port}"
  source_tags    = ["${module.mig1.target_tags}"]
  target_tags    = ["${module.mig2.target_tags}"]
  backends       = [
    { group = "${module.mig2.instance_group}" }
  ]
}
