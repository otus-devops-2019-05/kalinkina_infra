variable project {
  description = "Project ID"
}

variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}

variable disk_image {
  description = "Disk image"
}

variable private_key {
  description = "Path to the private key used for ssh access"
}

variable "app_count" {
  description = "Count of provisioned application nodes"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-base-app"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}
