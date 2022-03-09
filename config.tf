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
  cat <<EOF > /var/www/html/index.html
  <!DOCTYPE html>
  <html>
  <head>
    <title>StackPath - Google Cloud Platform Instance</title>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
    <style>
      html, body {
        background: #000;
        height: 100%;
        width: 100%;
        padding: 0;
        margin: 0;
        display: flex;
        justify-content: center;
        align-items: center;
        flex-flow: column;
      }
      img { width: 250px; }
      svg { padding: 0 40px; }
      p {
        color: #fff;
        font-family: 'Courier New', Courier, monospace;
        text-align: center;
        padding: 10px 30px;
      }
    </style>
  </head>
  <body>
    <img src="https://www.stackpath.com/content/images/logo-and-branding/stackpath-logo-standard-screen.svg">
    <p>This request was proxied from <strong>Google Cloud Platform</strong></p>
  </body>
  </html>
  EOF
  EOT
    }
}
