terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.13.0"
    }
  }
}

provider "docker" {
  #This is requied for Windows
  host    = "npipe:////.//pipe//docker_engine"
}

resource "docker_image" "ubuntu" {
  name         = "ubuntu:latest"
  keep_locally = false
}

resource "docker_container" "ubuntu_con" {
  image = docker_image.nginx.latest
  name  = "tutorial"
  ports {
    internal = 80
    external = 8000
  }
}
