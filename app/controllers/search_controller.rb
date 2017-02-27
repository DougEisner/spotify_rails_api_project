require 'httparty'
require 'byebug'
require 'pry'

class SearchController < ApplicationController

  def index
    @search_term = params[:search_term]

    get_artist_name_id
    return nil if @id.nil?

    albums = HTTParty.get("https://api.spotify.com/v1/artists/#{@id}/albums")

    @albums = get_albums(albums)
    #@albums is an array with 20 repeating hashes of all albums 20 times.
    @albums = @albums.first
    # Removes all the duplicate arrays. Shouldn't be needed, but get_albums duplicates the hash.
  end
end


def get_artist_name_id
  response = HTTParty.get("https://api.spotify.com/v1/search?q=#{@search_term}&type=artist")

  (return; @id = nil) if response['artists']['items'] == []

  @id = response["artists"]["items"].first["id"]

  # Id was not passed to the index function above w/o the @ instance variable symbol.
  @artist_name = response["artists"]["items"].first["name"]
end

def get_albums(albums)
  album_hash = {}
  albums['items'].map do |item|
    name = item['name']
    album_image = item['images'][1]['url']

    album_hash.merge!(name => album_image)
    # This merge function populates the hash and enforces uniqueness on key values. But it duplicates all values.
    #{name: name, album_image: album_image}
  end
end
