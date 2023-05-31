class Album
  attr_accessor :id, :title, :release_year, :artist_id

  def to_json(*args)
    {
      "id" => id,
      "title" => title,
      "release_year" => release_year,
      "artist_id" => artist_id
      # include other attributes you want to include in the JSON representation
    }.to_json(*args)
  end
end