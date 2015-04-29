json.array!(@points) do |point|
  json.extract! point, :name, :sport, :latitude, :longitude, :street_number, :route, :city, :country, :postal_code
  json.url point_url(point, format: :json)
end
