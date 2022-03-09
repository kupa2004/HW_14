terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.13.0"
    }
  }
}

provider "google" {
  # Configuration options
  credentials = file("cred.json")
  project = "solar-semiotics-343520"
  region  = "us-west1"
  zone    = "us-west1-b"
}

output "gcp_instance_ip" {
  value = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
}

resource "google_compute_instance" "default" {
  name         = "my-test14"
  machine_type = "f1-micro"
  zone         = "us-west1-b"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  tags = [
      "http-server"
    ]

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }
  metadata = {
      "startup-script" = <<EOT
  #!/bin/bash
  apt-get update
  apt-get install -y nginx
  cp index.html /var/www/html/index.html
  EOT
    }
}
