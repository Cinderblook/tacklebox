# Create a random shuffle from a list for usage in Spotify playlist creation
resource "random_shuffle" "artist" {
  input        = local.all_track_ids 
}

# Create the playlist
resource "spotify_playlist" "custom" {
  depends_on = [
      data.spotify_search_track.custom_count,
    ]
    
  
  name        = "Autogen-Katie"
  description = "This playlist was created by Terraform"
  public = true
  tracks = flatten([
      random_shuffle.artist.result
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
  # Concat all resulting lists together
  all_tracks = concat(data.spotify_search_track.custom_count[*])
  # Condense tupil list into regular list containing only ids
  all_track_ids = flatten(local.all_tracks[*].tracks[*].id)
  # Condense tupil list into regulat list containing only names
  all_track_names = flatten(local.all_tracks[*].tracks[*].name)
}

output "list" {
  value = local.all_track_names
}

