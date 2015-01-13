Band.delete_all
Artist.delete_all
Album.delete_all
genres = ['rock', 'jazz', 'country', 'pop', 'fusion', 'bosanova', 'jazz-rock', 'metal', 'thrash', 'black-metal', 'doom', 'soul', 'latin', 'relax']

50.times do |i|
  band = Band.create(name: "Band #{i}", description: "A product.")
  band.artists << Artist.new(first_name: "Artist #{i}")
  band.leaders << Artist.new(first_name: "Some #{i}")
  name = genres.rotate(i).first
  band.genres << Genre.find_or_create_by(name: name)
  band.rating = Rating.create!(value: (0..9).to_a.rotate(i).first)
  band.albums << Album.new(name: "New Album #{i}")
  band.save!
end

10.times do |i|
  a = Artist.create(first_name: "Artist #{i}", description: "A product.")
  a.albums << Album.new(name: "Album #{i}")
  a.save!
end