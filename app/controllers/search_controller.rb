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
    @albums = @albums.each[:name].uniq

    # binding.pry

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
  albums['items'].map do |item|
    name = item['name']
    album_image = item['images'][1]['url']
    # binding.pry - each time through album and album_image are given correct values. Is album being passed through?
    {name: name, album_image: album_image}
  end
end
