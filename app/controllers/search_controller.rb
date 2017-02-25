require 'httparty'
require 'byebug'
require 'pry'

class SearchController < ApplicationController

  def index
    @search_term = params[:search_term]

    get_artist_name_id
    return nil if @id.nil?

    albums = HTTParty.get("https://api.spotify.com/v1/artists/#{@id}/albums")

    @albums = albums['items'].map do |item|
      album = item['name']
      album_image = item['images'][1]['url']

      {albums: album, album_image: album_image}
    end
  end
end


def get_artist_name_id
  response = HTTParty.get("https://api.spotify.com/v1/search?q=#{@search_term}&type=artist")

  (return; @id = nil) if response['artists']['items'] == []

  @id = response["artists"]["items"].first["id"]

  # Id was not passed to the index function above w/o the @ instance variable symbol.
  @artist_name = response["artists"]["items"].first["name"]
end
