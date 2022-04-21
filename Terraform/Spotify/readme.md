# Overview
Manipulating spotify playlist using Terraform, because why not?

# Understanding the provider
For all Spotify API usage with Terraform, You must either run a oauth server locally and just provide the API key, or use something online and provide all 4 necessary features (api, token_id, user, and oauth_url). You will need to create a Spotify Developer account [here](https://developer.spotify.com/)

# Create .tfvars file
In this file, reference your `spotify_api_key`, `spotify_token_id`, `spotify_oauth_url`, and `spotify_user`
<br> I named mine `tfvariables.tfvars`. You can refer to tfvariables.tfvars.example within each folder for this.

## Useful Resources
Refer to this official spotify guide for creating a self-hosted oauth server, or using the free open source one the creater made: [Github](https://github.com/conradludgate/terraform-provider-spotify)
[Spotify Provider](https://registry.terraform.io/providers/conradludgate/spotify/latest/docs)
