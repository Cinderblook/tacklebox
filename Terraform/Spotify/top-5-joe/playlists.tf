# Creates playlist based on spotify search
resource "spotify_playlist" "custom" {
  name        = "Joe top 5"
  description = "This playlist was created by Terraform"
  public = true

  tracks = flatten([
    data.spotify_search_track.grant.tracks[*].id,
    data.spotify_search_track.barely.tracks[*].id,
    data.spotify_search_track.space.tracks[*].id,
    data.spotify_search_track.savant.tracks[*].id,
    data.spotify_search_track.virtual.tracks[*].id,
    data.spotify_search_track.noisia.tracks[*].id
  ])

depends_on = [
    data.spotify_search_track.grant,
    data.spotify_search_track.barely,
    data.spotify_search_track.space,
    data.spotify_search_track.savant,
    data.spotify_search_track.virtual,
    data.spotify_search_track.noisia
  ]
}


data "spotify_search_track" "grant" {
  artist = "Grant"
  #album = ""
  #year = ""
  limit = 10
  explicit = true
}
data "spotify_search_track" "barely" {
  artist = "Barely Alive"
  #album = ""
  #year = ""
  limit = 5
  explicit = true
}
data "spotify_search_track" "space" {
  artist = "Space Laces"
  #album = ""
  #year = ""
  limit = 5
  explicit = true
}
data "spotify_search_track" "savant" {
  artist = "Savant"
  #album = ""
  #year = ""
  limit = 5
  explicit = true
}
data "spotify_search_track" "virtual" {
  artist = "Virtual Riot"
  #album = ""
  #year = ""
  limit = 5
  explicit = true
}
data "spotify_search_track" "noisia" {
  artist = "Noisia"
  #album = ""
  #year = ""
  limit = 5
  explicit = true
}

# Output track results
output "Results" {
    value = resource.spotify_playlist.custom.tracks
}