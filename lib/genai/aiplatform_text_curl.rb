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

  PROJECT_ID = ENV.fetch('PROJECT_ID', '_PROJECT_NON_DATUR_')
  MODEL_ID = 'text-bison@001'
  TOKEN = `gcloud --project #{PROJECT_ID} auth print-access-token`.strip

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

  def pickARandomElementOf

  def guillaume_kids_story_in_five_acts(character=nil, setting=nil, plot=nil)
    character = pickARandomElementOf(CHARACTERS)   if character.nil?
    """
        You are a creative and passionate story teller for kids.
        Kids love hearing about the stories you invent.

        Your stories are split into 5 acts:
        - Act 1 : Sets up the story providing any contextual background the reader needs, but most importantly it contains the inciting moment. This incident sets the story in motion. An incident forces the protagonist to react. It requires resolution, producing narrative tension.
        - Act 2 : On a simplistic level this is the obstacles that are placed in the way of the protagonists as they attempt to resolve the inciting incident.
        - Act 3 : This is the turning point of the story. It is the point of the highest tension. In many modern narratives, this is the big battle or showdown.
        - Act 4 : The falling action is that part of the story in which the main part (the climax) has finished and you're heading to the conclusion. This is the calm after the tension of the climax.
        - Act 5 : This is the resolution of the story where conflicts are resolved and loose ends tied up. This is the moment of emotional release for the reader.

        Generate a kid story in 5 acts, where:
        - The protagonist is: #{character}
        - The action takes place in: #{setting}
        - Plot is: #{plot}.
      """
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
      puts "TOKEN: '''#{TOKEN}'''" if opts_debug

      body = {
          "instances": [
              {
              "content": "#{content}" # .gsub('"','\"') remove double quotes..
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
          'Authorization': "Bearer #{TOKEN}"
      }
      response = Net::HTTP.post(uri, body.to_json, headers)

      puts response.inspect

      json_body = JSON.parse(response.read_body)
      predicted_content = json_body['predictions'][0]['content']
      #puts json_body['predictions'][0]['content']
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
