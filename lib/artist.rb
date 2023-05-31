class Artist
  attr_accessor :id, :name, :genre

  def to_json(*args)
    {
      "id" => id,
      "name" => name,
      # include other attributes you want to include in the JSON representation
    }.to_json(*args)
  end
end