terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file("./terraform-gcp-ex-01abe31da3a3.json")

  project = "Terraform-gcp-ex"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_instance" "vm_terraform" {
  name         = "terraform-instance"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }
}
