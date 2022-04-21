variable "spotify_api_key" {
  type        = string
  description = "Set this as the APIKey that the authorization proxy server outputs"
}
variable "spotify_token_id" {
  type        = string
  description = "Token ID provided from oauth"
}
variable "spotify_user" {
  type        = string
  description = "username for oauth"
}
variable "spotify_oauth_url" {
  type        = string
  description = "url path of oauth server"
}
variable "artist_list" {
  type = list
  description = "Spotify Artists"
}