=begin
# This is NOT an ideal way to invoke the library.
# However I want able to invoke the proper library when I tried.

TODOs:
* region is now hardcoded as us-central1.
* login is via curl and gcloud :/
* TOKEN should be at very least cached for 10min or so.
=end

module Genai
  # Only allow authenticated admins access to precious resources.
  module AiplatformTextCurl


    VERSION = '0.2_18jun23'

    require 'net/http'
    require 'uri'
    require 'json'
    require 'yaml'

    #PROJECT_ID ||= ENV.fetch('PROJECT_ID') # from intiializers
    #GCLOUD_ACCESS_TOKEN ||= `gcloud --project '#{PROJECT_ID}' auth print-access-token`.strip

    MODEL_ID = 'text-bison@001'


    # taken by my buddy Guillaume: https://github.com/glaforge/bedtimestories/blob/main/src/main/resources/public/index.html
    CHARACTERS =    [
      "a funny little princess with a strong character",
      "a young astronaut exploring space",
      "a fearless firefighter",
      "a cute little cat with a long and silky fur",
      "a gentle dragon with a colorful skin",
      "a brave knight in a shiny silver armor",
      "a clever wizard who uses his magic to help others",
      "a curious explorer who travels to far-off lands",
      "a mischievous fairy who causes all sorts of trouble",
      "a talking animal who is the best friend of a young child",
      "a magical creature who grants wishes",
      "a time traveler who takes children on adventures to different eras",
      "a spy who solves mysteries and saves the day",
      "a superhero who fights crime and protects the innocent",
    ]
    SETTINGS = [
      "in a big gray castle, centuries ago",
      "on a space station orbiting a distant planet, in year 2135",
      "in a big bustling city",
      "in an enchanted forest",
      "in a jungle full of dangerous wild animals",
      "in a small village on a quiet island",
      "in a busy train station of a futuristic city full of high skyscrapers",
      "in a deserted beach, on a far away island in the middle of the ocean",
      "in a mysterious cave at the bottom of a mountain",
    ]
    PLOTS = [
      "her little sister was kidnapped by a nasty old witch",
      "the sun is erupting dangerously",
      "a shower of comets is setting the town on fire at every corner",
      "an evil dog with long ears is barking at all cute animals",
      "the baboon king is threatening all animals and stealing their food",
      "dangerous asteroids hosting mysterious lifeforms",
      "discovery of a secret portal enabling travel to worlds of danger and excitement",
      "discovery of a flying superpower",
      "a mission to investigate a mysterious object that has appeared in orbit around the Earth",
      "rescue of a cat from a burning building",
      "a mission to break the spell that has been cast on her kingdom",
      "solving the mystery of a haunted house",
    ]

    def pickARandomElementOf(arr)
      # https://stackoverflow.com/questions/3482149/how-do-i-pick-randomly-from-an-array
      # Random sample
      arr.sample
    end
    # def guillaume_kids_story_in_five_acts()
    #   guillaume_kids_story_in_five_acts(nil, nil, nil, nil)
    # end

    # https://medium.datadriveninvestor.com/ruby-keyword-arguments-817ed243b4e2
    def guillaume_kids_story_in_five_acts(opts={})
      # kid_description:, character:, setting:, plot:)
      kid_description = opts.fetch :kid_description, 'A blue-eyed afroamerican 6-year-old red-haired girl called Foobar Baz' # if kid_description.nil?
      character = opts.fetch :character, pickARandomElementOf(CHARACTERS) #   if character.nil?
      setting = opts.fetch :setting, pickARandomElementOf(SETTINGS) #  if setting.nil?
      plot = opts.fetch :plot, pickARandomElementOf(PLOTS) #  if plot.nil?
      return "You are a creative and passionate story teller for young kids.
          Kids love hearing about the stories you invent.

          Your stories are split into five acts as it follows (please stick to this plan):
          - Act 1 : Sets up the story providing any contextual background the reader needs, but most importantly it contains the inciting moment. This incident sets the story in motion. An incident forces the protagonist to react. It requires resolution, producing narrative tension.
          - Act 2 : On a simplistic level this is the obstacles that are placed in the way of the protagonists as they attempt to resolve the inciting incident.
          - Act 3 : This is the turning point of the story. It is the point of the highest tension. In many modern narratives, this is the big battle or showdown.
          - Act 4 : The falling action is that part of the story in which the main part (the climax) has finished and you're heading to the conclusion. This is the calm after the tension of the climax.
          - Act 5 : This is the resolution of the story where conflicts are resolved and loose ends tied up. This is the moment of emotional release for the reader.

          Generate a kid story in five acts, where:
          - The protagonist is: #{character}.
          - The action takes place in: #{setting}.
          - Plot is: #{plot}.
          - My kid is #{kid_description}.
      "
    end

    def generate_story(input_blurb)
      "TODO(ricc): take tamplate from https://github.com/glaforge/bedtimestories/blob/main/src/main/groovy/com/google/cloud/devrel/bedtimestories/StoryMakerController.groovy "
    end

    def ai_curl_by_content(content, region='us-central1', opts={})
        # options
        opts_debug = opts.fetch 'DEBUG', false
        # filling empty values
        project_id = PROJECT_ID

        #ai_url = "https://us-central1-aiplatform.googleapis.com/v1/projects/#{project_id}/locations/us-central1/publishers/google/models/text-bison:predict"
        ai_url = "https://us-central1-aiplatform.googleapis.com/v1/projects/#{project_id}/locations/us-central1/publishers/google/models/#{MODEL_ID}:predict"

        puts("ai_url: #{ai_url}") if opts_debug
        uri = URI(ai_url)

        puts("uri:    #{uri}") if opts_debug
        #puts "TOKEN: '''#{GCLOUD_ACCESS_TOKEN}'''" if opts_debug

        body = {
            "instances": [
                {
                "content": content, # "#{content.gsub('"','\"')}" #  remove double quotes..
                }
            ],
            "parameters": {
                "temperature": 0.8,
                "maxOutputTokens": 1000,
                "topP": 0.8,
                "topK": 40
            }
        }
        puts "BODY: '''#{body}'''" if opts_debug
        headers = {
            'Content-Type': 'application/json',
            'Authorization': "Bearer #{GCLOUD_ACCESS_TOKEN}"
        }
        response = Net::HTTP.post(uri, body.to_json, headers)

        puts('ai_curl_by_content(): response.inspect = ', response.inspect)

        json_body = JSON.parse(response.read_body)
        #puts response
        predicted_content = (json_body['predictions'][0]['content'] rescue nil)
        return nil if predicted_content.nil?
        return response, predicted_content
    end

    def add_to_yaml_db(story_idea, content, yaml_filename="stories.yaml")
      # TODO(ricc): add a 'create if not exist' flag. These APIs are expensive you dont want to lose their output.
        yaml_string = File.read(yaml_filename)
        data = YAML.load(yaml_string)
        puts data # ["apache_vhosts"]
        new_element = {
            'title' => 'TODO', # can be manual or we can use another API :)
            'story_idea' => story_idea,
            'content' => content,
            'date' => Time.now,
        }
        data << new_element
        output = YAML.dump data
        puts output
        File.write("stories.yaml", output)
    end

    def sample_invokation()
        puts 'Now I doi a manual curl'
        story_idea = "Write \"a kid story about Sebowski ' ' ci\"ao the Egyptologist teleported in ancient Egypt to meet the evil twin of Tutankhamen"
        response, content = ai_curl_by_content(story_idea, PROJECT_ID, :debug => true)
        puts "Content received: '''#{content}'''"
        #add_to_yaml_db(story_idea, content)
        puts '👍 Everything is ok. But Riccardo you should think about 🌍rewriting it in Terraform🌍'
        content
    end

  end
end

#extend Genai::AiplatformTextCurl
#ai_curl_by_content('blah blah blah poo')
#sample_invokation()
