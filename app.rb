# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require 'sinatra/json'
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  post '/albums' do
    new_title = params[:title]
    new_release_year = params[:release_year]
    new_artist_id = params[:artist_id]

    album = Album.new
    album.title = new_title
    album.release_year = new_release_year
    album.artist_id = new_artist_id

    album_repo = AlbumRepository.new
    album_repo.create(album)
    
    json nil
  end

  get '/albums' do
    album_repo = AlbumRepository.new
    result = album_repo.all
    json result
  end

  post '/artists' do
    new_name = params[:name]
    new_genre = params[:genre]

    artist = Artist.new
    artist.name = new_name
    artist.genre = new_genre

    artist_repo = ArtistRepository.new
    artist_repo.create(artist)
    
    json nil
  end

  get '/artists' do
    artist_repo = ArtistRepository.new
    result = artist_repo.all
    result.to_json
  end
end