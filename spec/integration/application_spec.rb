require "spec_helper"
require "rack/test"
require_relative '../../app'

RSpec.describe Application do
  include Rack::Test::Methods

  let(:app) { Application }

  def reset_albums_table
    seed_sql = File.read('spec/seeds/albums_seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_1_test' })
    connection.exec(seed_sql)
  end
  
 
  before(:each) do 
    reset_albums_table
  end

  context "/albums" do
    it 'returns 200 OK with post method' do
      post '/albums', { title: 'Voyage', release_year: 2022, artist_id: 2 }

      expect(last_response.status).to eq(200)

      album = AlbumRepository.new.all
      expect(album.last.title).to eq("Voyage")
    end 

    it 'returns 200 OK and albums data' do
      get '/albums'

      expect(last_response.status).to eq(200)

      album_repo = AlbumRepository.new
      expected_response = album_repo.all.to_json

      expect(last_response.body).to eq(expected_response)
    end  
  end

  context "POST /artists" do
    it 'returns 200 OK' do
      post '/artists', { name: 'Wild nothing', genre: 'Indie' }

      expect(last_response.status).to eq(200)

      artist = ArtistRepository.new.all
      expect(artist.last.name).to eq('Wild nothing')
      expect(artist.last.genre).to eq('Indie')
    end

    it 'returns 200 OK and artists data' do
      get '/artists'

      expect(last_response.status).to eq(200)

      artist_repo = ArtistRepository.new
      expected_response = artist_repo.all.to_json

      expect(last_response.body).to eq(expected_response)
    end
  end

  context "GET /albums/id" do
      it "returns an album data" do
      response = get('/albums/1')
  
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Doolittle</h1>')
    end
  end
end
