terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.13.0"
    }
  }
}

#export GOOGLE_CLOUD_KEYFILE_JSON="cred-gcp.json"

provider "google" {
  # Configuration options
  credentials = file("cred-gcp.json")
  project = "solar-semiotics-343520"
  region  = "us-west1"
  zone    = "us-west1-b"
}

resource "google_compute_instance" "default" {
  name         = "my-test14"
  machine_type = "f1-micro"
  zone         = "us-west1-b"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  network_interface {
    network = "default"
  }
}
