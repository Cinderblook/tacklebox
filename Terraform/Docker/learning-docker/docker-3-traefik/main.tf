terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.13.0"
    }
  }
}

provider "docker" {
  #This is required for Windows to run Docker
  host    = "npipe:////.//pipe//docker_engine"
}

# User Module to configure traefik
module "docker-traefik" {
  source = "github.com/colinwilson/terraform-docker-traefik-v2"

  password                   = "Password1234"         # optional
  traefik_network_attachable = true                  # optional
  traefik_network            = "traefik_network"
  acme_email                 = "traefik@ajb.com"
  hostname                   = "traefik.ajb.com"
  #live_cert                  = true                  # optional
  #lets_encrypt_keytype       = "EC384"               # optional
  #lets_encrypt_resolvers     = ["cloudflare"]        # optional
}