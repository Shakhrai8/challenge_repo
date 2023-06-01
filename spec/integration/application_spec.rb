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
      response = get('/albums')

      expect(response.status).to eq(200)

      # album_repo = AlbumRepository.new
      # expected_response = album_repo.all.to_json
      # gsub replaces every \n with '', example:
      # expect(response.body.gsub("\n", '')).to include('<div>        Title: Doolittle        Released: 1989      </div>')
      # squeeze(' ') will collapse multiple consecutive spaces into a single space
      response_body = response.body.gsub("\n", '').squeeze(' ')
      expect(response_body).to include('<a href="/albums/1"> -- Title: Doolittle -- Released: 1989 </a>')
    end  
  end

  # context "POST /artists" do
  #   it 'returns 200 OK' do
  #     post '/artists', { name: 'Wild nothing', genre: 'Indie' }

  #     expect(last_response.status).to eq(200)

  #     artist = ArtistRepository.new.all
  #     expect(artist.last.name).to eq('Wild nothing')
  #     expect(artist.last.genre).to eq('Indie')
  #   end

  #   it 'returns 200 OK and artists data' do
  #     response = get('/artists')

  #     expect(response.status).to eq(200)

  #     response_body = response.body.gsub("\n", '').squeeze(' ')
  #     expect(response_body).to include('<a href="/artists/1"> -- Name: Pixies -- Genre: Rock </a>')
  #   end
  # end

  context "GET /albums/id" do
    it "returns an album data" do
      response = get('/albums/1')
  
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Doolittle</h1>')
    end
  end

  context "GET /artists/id" do
    it "returns an album data" do
      response = get('/artists/1')
  
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Pixies</h1>')
    end
  end

  context "GET /albums/new" do
    it 'returns the form page' do
      response = get('/albums/new')
  
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Add a New Album</h1>')
  
      # Assert we have the correct form tag with the action and method.
      expect(response.body).to include('<form action="/albums" method="post">')
  
      # We can assert more things, like having
      # the right HTML form inputs, etc.
    end
  end
  
  context "POST /albums" do
    it 'returns a success page' do
      # We're now sending a POST request,
      # simulating the behaviour that the HTML form would have.
      response = post '/albums', { title: 'Im Title', release_year: 2000, artist_id: 1 }
  
      expect(response.status).to eq(200)
      expect(response.body).to include('<p>The album has been successfully created.</p>')
    end
  
    it 'responds with 400 status if parameters are invalid' do
      post '/albums', {
        title: '',
        release_year: '1990',
        artist_id: '1'
      }
    
      expect(last_response.status).to eq(400)
    end
  end

  context "GET /artists/new" do
    it 'returns the form page' do
      response = get('/artists/new')
  
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Add a New Artist</h1>')
  
      # Assert we have the correct form tag with the action and method.
      expect(response.body).to include('<form action="/artists" method="post">')
  
      # We can assert more things, like having
      # the right HTML form inputs, etc.
    end
  end
  
  context "POST /artists" do
    it 'returns a success page' do
      # We're now sending a POST request,
      # simulating the behaviour that the HTML form would have.
      response = post '/artists', { name: 'Wild nothing', genre: 'Indie' }
  
      expect(response.status).to eq(200)
      expect(response.body).to include('<p>New artist has been successfully created.</p>')
    end
  
    it 'responds with 400 status if parameters are invalid' do
      post '/artists', {
        name: '',
        genre: 'Pop'
      }
    
      expect(last_response.status).to eq(400)
    end
  end
end
