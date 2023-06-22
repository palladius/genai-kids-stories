# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

puts 'Creating a couple of test kids, completely randomic...'

create_kids = Kid.find_by_nick('AJ').nil?

puts "1. Creating fake child..."
doll = Kid.create(
  id: 1337,
  name: 'Fake',
  nick: 'doll',
  date_of_birth: '2021-01-30',
  #app/assets/images/kids/doll.jpg
)
puts doll.errors.full_messages
path = 'app/assets/images/kids/doll.jpg'

puts "2. Attaching avatar..."
doll.avatar.attach(path)
#Story.last.attach_test_image
doll.save
puts(doll)

exit 42

if create_kids
  aj = Kid.create_kid_on_steorids(
    name: 'Alessandro',
    surname: 'Carlesso', nick: 'AJ',
    date_of_birth: '2018-01-30', is_male: true,
    visual_description: '5-year-old brown-eyed boy with light brown hair',
    internal_info: 'My oldest son',
    user_id: 1,
    fixture_avatar: 'aj.png', # fixture :)
  )
  seby = Kid.create_kid_on_steorids(
    id: 2020,
    name: 'Sebastian Leonardo',
    nick: 'Seby',
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
begin
  puts 'Skipping kids - I presume theyre already created.'
end
end
#######################
# Stories
#######################
#STORIES_FIXTURE_IMAGES_DIR = "#{Rails.root}/db/fixtures/stories/"

seby_story1_body = "Sebastian was a fearless firefighter. He loved his job and he was always ready to help people in need. One day, Sebastian was called to a fire at a busy train station in Zurich. When he arrived, he saw that the fire was spreading quickly and there were people trapped inside. Sebastian knew he had to act fast. He ran into the burning building and started to help people to safety.

Sebastian was working hard to save people, but the fire was getting worse. The smoke was thick and the heat was intense. Sebastian could feel his lungs burning and his skin starting to blister. But he kept going. He knew he had to save everyone.

Suddenly, Sebastian heard a cry for help. He turned around and saw a little girl trapped in a room on the second floor. The flames were all around her and she was starting to panic. Sebastian knew he had to get to her, but the fire was too intense. He looked around for something to use to create a path to the girl.

Sebastian saw a long ladder leaning against the side of the building. He ran over to the ladder and started to climb up. The ladder was shaking and the flames were licking at his heels, but Sebastian kept going. He knew he had to save the little girl.

Sebastian finally reached the second floor and he ran to the room where the little girl was trapped. He kicked down the door and pulled her out of the room. The little girl was crying and her clothes were singed, but she was alive. Sebastian carried her to safety and then he went back into the burning building to find more people.

Sebastian searched the burning building for hours, but he couldn't find anyone else. He was about to give up when he heard a noise coming from the back of the building. He ran to the back of the building and saw a giraffe trapped in a cage. The giraffe was scared and it was trying to break free, but it couldn't. Sebastian knew he had to save the giraffe.

Sebastian ran to the cage and started to work on the lock. The lock was old and rusty and it was hard to open, but Sebastian finally managed to get it open. The giraffe ran out of the cage and into Sebastian's arms. Sebastian was so happy that he had saved the giraffe.

Sebastian and the giraffe were both safe. The fire was out and the people who had been trapped inside were all safe. Sebastian was a hero. He had saved the little girl and the giraffe and he had put his own life in danger to do it. Sebastian was proud of what he had done and he knew that he would never forget it.
"

aj_story2_body = "C'era una volta un giovane coraggioso cavaliere di 5 anni con un'armatura d'argento lucente di nome Alessandro. Ha vissuto nella città di Zurigo con i suoi genitori. Alessandro amava andare all'avventura ed esplorare posti nuovi. Un giorno, ha sentito parlare di una casa infestata in città. Decise di andare a indagare.

Quando Alessandro arrivò alla casa infestata, vide che era un grande edificio antico. Era buio e cupo e le finestre erano sprangate. Alessandro era spaventato, ma ha deciso di entrare.

Mentre attraversava la casa, Alessandro sentì strani rumori. Vide ombre che si muovevano nell'oscurità. Stava cominciando ad avere davvero paura. Voleva scappare, ma sapeva che doveva scoprire cosa infestava la casa.

Alessandro si addentrava sempre più in casa. Arrivò in una stanza piena di ragnatele. Vide una vecchia cassapanca nell'angolo della stanza. Si avvicinò al baule e lo aprì. All'interno del forziere trovò una maschera d'oro.


Alessandro si mise la maschera. Improvvisamente, sentì uno strano potere salire nel suo corpo. Sapeva che la maschera era la fonte dell'ossessione. Doveva trovare un modo per liberarsene.

Alessandro corse fuori di casa e in strada. Vide un gruppo di persone raccolte attorno a un fuoco. Andò da loro e raccontò loro della casa infestata. Le persone hanno ascoltato il racconto di Alessandro e poi lo hanno aiutato a liberarsi della mascherina.


La gente ha portato la maschera in cima a una collina e l'ha bruciata. Mentre la maschera bruciava, lo spirito di Tutankhamon veniva liberato. Lo spirito era finalmente in pace.

Alessandro era un eroe. Aveva salvato la città dalla casa stregata. Gli zurighesi gli erano grati. Hanno organizzato una festa in suo onore. Alessandro era felice di aver aiutato gli zurighesi. Sapeva che non avrebbe mai dimenticato la sua avventura nella casa stregata.
"

seby = Kid.find_by_nick('Seby')


seby_story1 = Story.create(
  id: 2020,
  title: 'Seby firefighter saves a giraffe',
  genai_input: 'TODO(ricc) from Guillaume',
  genai_output: seby_story1_body,
   # genai_summary:text TODO
  internal_notes: '(story is in Engish)',
  user_id: 1,
  kid: Kid.find_by_nick('Seby'),
) rescue Story.find(2020)

seby_story1.attach_cover('seby-firefighter.png')

aj_story1 = Story.create(
  id: 2018,
  title: 'Il cavaliere Alessandro e lo spirito di Tutankhamen  ',
  genai_input: 'Useless since im seeding',
  genai_output: aj_story2_body,
   # genai_summary:text TODO
  internal_notes: '(story is in Italian)',
  user_id: 1,
  kid: Kid.find_by_nick('AJ'),
) rescue  Story.find(2018)
aj_story1.attach_cover('aj-knight.png')

joke_story = Story.create(
  id: 142,
  #title: 'Il cavaliere Alessandro e lo spirito di Tutankhamen  ',
  genai_input: 'Tell me a funny joke that would make a Google Engineer laugh. Make the story not too short.',
  #genai_output: aj_story2_body,
   # genai_summary:text TODO
  internal_notes: '(joke from seeds)',
  user_id: 1,
  kid: Kid.last,
) rescue Story.find(142)

#puts seby_story1.errors
#puts "📚 Story just created: #{seby_story1}. Errors: #{seby_story1.errors.full_messages}" # if opts_debug
#puts "📚 Story just created: #{aj_story1}. Errors: #{aj_story1.errors.full_messages}" # if opts_debug
[seby_story1, aj_story1, joke_story ].each do |seeded_story|
  error_messages = seeded_story.errors.full_messages
  puts "📚 Story just created: #{seeded_story}. Errors: #{error_messages == [] ? '✅ ' : error_messages.join(',') }" # if opts_debug
end
