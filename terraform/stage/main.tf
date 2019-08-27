terraform {
  # Версия terraform
  required_version = ">=0.11.7"
}

provider "google" {
  # Версия провайдера
  version = "2.0.0"
  project = "${var.project}"
  region  = "europe-west1"
  zone    = "europe-west1-b"
  alias   = "app"
}

provider "google" {
  # Версия провайдера
  version = "2.0.0"
  project = "${var.project}"
  region  = "europe-west4"
  zone    = "europe-west4-c"
  alias   = "db"
}

module "app" {
  source          = "../modules/app"
  public_key_path = "${var.public_key_path}"
  app_disk_image  = "${var.app_disk_image}"
  providers = {
    google = "google.app"
  }
}

module "db" {
  source          = "../modules/db"
  public_key_path = "${var.public_key_path}"
  db_disk_image   = "${var.db_disk_image}"
  providers = {
    google = "google.db"
  }
}

module "vpc" {
  source        = "../modules/vpc"
  source_ranges = ["0.0.0.0/0"]
  providers = {
    google = "google.app"
  }
}
