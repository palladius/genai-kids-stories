# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

puts 'Creating a couple of test kids, completely randomic...'

aj = Kid.create(name: 'Alessandro', surname: 'Carlesso', nick: 'AJ',
  date_of_birth: '2018-01-30', is_male: true,
  visual_description: '5-year-old brown-eyed boy with light brown hair',
  internal_info: 'My oldest son', user_id: 1
)
seby = Kid.create(name: 'Sebastian Leonardo', nick: 'Seby Leo',
  date_of_birth: '2020-05-18', is_male: true,
  #visual_description: '5-year-old brown-eyed boy with light brown hair',
  internal_info: 'My younger son', user_id: 1
)
seby.avatar.attach(io: File.open("#{Rails.root}/storage/seby.png"), filename: 'seby.png')
seby.save
puts aj
