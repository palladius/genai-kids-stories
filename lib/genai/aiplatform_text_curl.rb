=begin
# This is NOT an ideal way to invoke the library.
# However I want able to invoke the proper library when I tried.

TODOs:
* region is now hardcoded as us-central1.
* login is via curl and gcloud :/
* TOKEN should be at very least cached for 10min or so.
=end

module RiccGenaiGcpTextCurl

  VERSION = '0.1_18jun23'

  require 'net/http'
  require 'uri'
  require 'json'
  require 'yaml'

  PROJECT_ID = ENV.fetch('PROJECT_ID', '_PROJECT_NON_DATUR_')
  MODEL_ID = 'text-bison@001'
  TOKEN = `gcloud --project #{PROJECT_ID} auth print-access-token`.strip

  def generate_story(input_blurb)
    "TODO(ricc): take tamplate from https://github.com/glaforge/bedtimestories/blob/main/src/main/groovy/com/google/cloud/devrel/bedtimestories/StoryMakerController.groovy "
  end

  def ai_curl_by_content(content, project_id, region='us-central1', opts={})
      opts_debug = opts.fetch 'DEBUG', false

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
  end


end

extend RiccGenaiGcpTextCurl
sample_invokation()
