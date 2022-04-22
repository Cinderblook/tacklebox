terraform {
  required_providers {
    spotify = {
      source = "conradludgate/spotify"
      version = "0.2.7"
    }
  }
}

provider "spotify" {
  # Refernced in tfvariables.tfvars
  auth_server = "${var.spotify_oauth_url}"
  api_key = "${var.spotify_api_key}"
  username = "${var.spotify_user}"
  token_id = "${var.spotify_token_id}"
}

