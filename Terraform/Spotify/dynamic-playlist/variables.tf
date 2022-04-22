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
variable "playlist_name" {
  type        = string
  description = "name of playlist"
}
variable "playlist_desc" {
  type        = string
  description = "desc of playlist"
}
variable "artist_list" {
  type = list
  description = "Spotify Artists"
}
variable "searchterm_list" {
  type = list
  description = "Spotify Search Terms"
}
