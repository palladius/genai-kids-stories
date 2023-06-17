# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

puts 'Creating a couple of test kids, completely randomic...'

aj = Kid.create_kid_on_steorids(name: 'Alessandro', surname: 'Carlesso', nick: 'AJ2',
  date_of_birth: '2018-01-30', is_male: true,
  visual_description: '5-year-old brown-eyed boy with light brown hair',
  internal_info: 'My oldest son',
  user_id: 1,
  fixture_avatar: 'aj.png', # fixture :)
)
seby = Kid.create_kid_on_steorids(name: 'Sebastian Leonardo', nick: 'Seby Leo2',
  date_of_birth: '2020-05-18', is_male: true,
  #visual_description: '5-year-old brown-eyed boy with light brown hair',
  internal_info: 'My younger son', user_id: 1,
  fixture_avatar: 'seby.png',
  #:fixture_avatar: 'colon.png',
)

anonymous = Kid.create_kid_on_steorids(
  name: 'Kimiko-san',
  surname: 'Watanabe',
  nick: 'Kimiko',
  date_of_birth: '2002-05-18',
  is_male: false,
  visual_description: '15-year-old brown-eyed japanese girl with long black hair',
  internal_info: 'Fake person',
  user_id: 1,
# NO fixture_avatar > I want the default
)
puf = Kid.create_kid_on_steorids(
  name: 'Puffin',
  surname: 'Mc Muffin',
  nick: 'Puff',
  date_of_birth: '2012-12-29',
  is_male: true,
  visual_description: 'grown up boy who looks like a puffin with a yellow hat',
  internal_info: 'Fake person inspired to my avatar..',
  user_id: 1,
  fixture_avatar: 'puffin-cappello-giallo.png',
)
