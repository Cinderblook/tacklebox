# Create the playlist
resource "spotify_playlist" "custom" {
  depends_on = [
      data.spotify_search_track.custom_count,
    ]
    
  
  name        = var.playlist_name
  description = var.playlist_desc
  public = true
  tracks = flatten([
      local.all_track_ids 
  ])
  }
# Find ids for songs
data "spotify_search_track" "custom_count" {
  count = length(var.artist_list)
  artist = "${var.artist_list[count.index]}"
  limit = 10
  explicit = true
}
# Local Variables to concat id lists into  one
locals {
  depends_on = [data.spotify_search_track.custom_count]
  all_tracks = concat(data.spotify_search_track.custom_count[*])
  all_track_ids = flatten(local.all_tracks[*].tracks[*].id)
  all_track_names = flatten(local.all_tracks[*].tracks[*].name)
}

output "list" {
  value = local.all_track_names
}

