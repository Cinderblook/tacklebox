# Create the playlist
resource "spotify_playlist" "custom" {
  depends_on = [
      data.spotify_search_track.artist,
      data.spotify_search_track.searchterm
    ]
    
  
  name        = "Autogen-Dynamic"
  description = "This playlist was created by Terraform"
  public = true
  tracks = flatten([
      local.artist_track_ids,
      local.searchterm_track_ids
  ])
  }
# Find ids for songs
data "spotify_search_track" "artist" {
  count = length(var.artist_list)
  artist = "${var.artist_list[count.index]}"
  limit = 10
  explicit = true
}
data "spotify_search_track" "searchterm" {
  count = length(var.searchterm_list)
  name = "${var.searchterm_list[count.index]}"
  limit = 10
  explicit = true
}
# Local Variables to concat id lists into  one
locals {
  depends_on = [data.spotify_search_track.artist]
  # Artist Lists
  artist_tracks = concat(data.spotify_search_track.artist[*])
  artist_track_ids = flatten(local.artist_tracks[*].tracks[*].id)
  artist_track_names = flatten(local.artist_tracks[*].tracks[*].name)
  # Search Term Lists
  searchterm_tracks = concat(data.spotify_search_track.searchterm[*])
  searchterm_track_ids = flatten(local.searchterm_tracks[*].tracks[*].id)
  searchterm_track_names = flatten(local.searchterm_tracks[*].tracks[*].name)  
}

output "artist_list" {
  value = local.artist_track_names
}
output "searchterm_list" {
  value = local.artist_track_names
}


