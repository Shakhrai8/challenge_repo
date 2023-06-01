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

  get '/albums/new' do
    return erb(:new_album)
  end
  
  def invalid_request_parameters?
    # Are the params nil?
    return true if params[:title].nil? || params[:release_year].nil? || params[:artist_id].nil?
  
    # Are they empty strings?
    return true if params[:title].empty? || params[:release_year].empty? || params[:artist_id].empty?
  
    return false
  end
  
  post '/albums' do
    if invalid_request_parameters?
      status 400
      return ''
    end
  
    new_title = params[:title]
    new_release_year = params[:release_year]
    new_artist_id = params[:artist_id]
  
    album = Album.new
    album.title = new_title
    album.release_year = new_release_year
    album.artist_id = new_artist_id
  
    album_repo = AlbumRepository.new
    album_repo.create(album)
  
    return erb(:post_created)
  end
  
  get '/artists/new' do
    return erb(:new_artist)
  end
  
  def invalid_request_parameters_artist?
    # Are the params nil?
    return true if params[:name].nil? || params[:genre].nil? 
  
    # Are they empty strings?
    return true if params[:name].empty? || params[:genre].empty? 
  
    return false
  end
  
  post '/artists' do
    if invalid_request_parameters_artist?
      status 400
      return ''
    end
  
    new_name = params[:name]
    new_genre = params[:genre]

    artist = Artist.new
    artist.name = new_name
    artist.genre = new_genre

    artist_repo = ArtistRepository.new
    artist_repo.create(artist)
  
    return erb(:artist_post_created)
  end

  get '/albums' do
    album_repo = AlbumRepository.new
    result = album_repo.all
    erb :albums, locals: { result: result }
  end

  get '/artists' do
    artist_repo = ArtistRepository.new
    result = artist_repo.all
    erb :artists, locals: {result: result}
  end

  get '/albums/:id' do
    album_repo = AlbumRepository.new
    artist_repo = ArtistRepository.new

    @album = album_repo.find(params[:id])
    @artist = artist_repo.find(@album.artist_id)
    
    return erb(:album)

  end

  get '/artists/:id' do
    artist_repo = ArtistRepository.new

    @artist = artist_repo.find(params[:id])
    
    return erb(:artist)
  end
end