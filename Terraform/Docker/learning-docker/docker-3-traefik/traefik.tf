resource "docker_image" "traefik" {
  name         = "traefik:latest"
  keep_locally = false
}

resource "docker_container" "traefik" {
  image = docker_image.traefik.latest
  name  = "traefiksite"
  ports {
    internal = 80
    external = 8001
  }
}
