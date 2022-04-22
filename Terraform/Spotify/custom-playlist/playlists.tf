# Creates playlist based on spotify search
resource "spotify_playlist" "custom" {
  name        = var.playlist_name
  description = var.playlist_desc
  public = true

  tracks = flatten([
    data.spotify_search_track.custom.tracks[*].id
  ])

depends_on = [
    data.spotify_search_track.custom
  ]
}

data "spotify_search_track" "custom" {
  name = "sea shanty"
  #artist = ""
  #album = ""
  #year = ""
  limit = 10
  explicit = true
}

# Output track results
output "Results" {
    value = data.spotify_search_track.custom.tracks
}