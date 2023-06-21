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


    VERSION = '0.3_21jun23'

    require 'net/http'
    require 'uri'
    require 'json'
    require 'yaml'
    require 'base64'

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

    def yellow(s);  "\033[1;33m#{s}\033[0m" ; end
    def red(s);  "\033[1;31m#{s}\033[0m" ; end
    #def white(s);  "\033[1;33m#{s}\033[0m" ; end

    def pickARandomElementOf(arr)
      # https://stackoverflow.com/questions/3482149/how-do-i-pick-randomly-from-an-array
      # Random sample
      arr.sample
    end

    # https://medium.datadriveninvestor.com/ruby-keyword-arguments-817ed243b4e2
    def guillaume_kids_story_in_five_acts(opts={})
      # kid_description:, character:, setting:, plot:)
      kid_description = opts.fetch :kid_description, 'A blue-eyed afroamerican 6-year-old red-haired girl called Foobar Baz' # if kid_description.nil?
      character = opts.fetch :character, pickARandomElementOf(CHARACTERS) #   if character.nil?
      setting = opts.fetch :setting, pickARandomElementOf(SETTINGS) #  if setting.nil?
      plot = opts.fetch :plot, pickARandomElementOf(PLOTS) #  if plot.nil?
      return "You are a creative and passionate story teller for young kids.
          Kids love hearing about the stories you invent.

          Your stories are split into five acts as it follows (please stick to this plan and enumerate those explicitly):
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
        project_id = opts.fetch :project_id , PROJECT_ID
        gcloud_access_token = opts.fetch :gcloud_access_token , GCLOUD_ACCESS_TOKEN
        model_id = opts.fetch :model_id , MODEL_ID

        #ai_url = "https://us-central1-aiplatform.googleapis.com/v1/projects/#{project_id}/locations/us-central1/publishers/google/models/text-bison:predict"
        ai_url = "https://us-central1-aiplatform.googleapis.com/v1/projects/#{project_id}/locations/us-central1/publishers/google/models/#{model_id}:predict"

        puts("ai_url: #{ai_url}") if opts_debug
        uri = URI(ai_url)

        puts("uri:    #{uri}") if opts_debug


        body = {
            "instances": [
                {
                "content": content,
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
            'Authorization': "Bearer #{gcloud_access_token}"
        }
        response = Net::HTTP.post(uri, body.to_json, headers)

        puts("ai_curl_by_content(): response.inspect = '#{response.inspect}'")

        json_body = JSON.parse(response.read_body)
        predicted_content = (json_body['predictions'][0]['content'] rescue nil)
        return nil if predicted_content.nil?
        return response, predicted_content
    end



    def ai_curl_images_by_content(content,  opts={})
      # options
      opts_debug = opts.fetch 'DEBUG', false

      # filling empty values
      project_id = opts.fetch :project_id , PROJECT_ID
      gcloud_access_token = opts.fetch :gcloud_access_token , GCLOUD_ACCESS_TOKEN
      model_id = opts.fetch :model_id , MODEL_ID
      region = opts.fetch :region , 'us-central1'

      ai_url = "https://us-central1-aiplatform.googleapis.com/v1/projects/#{project_id}/locations/us-central1/publishers/google/models/imagegeneration:predict"
      puts("ai_url: #{ai_url}") if opts_debug

      uri = URI(ai_url)
      puts("uri:    #{uri}") if opts_debug

      puts "#{Story.emoji} Story.#{self.id}. Generating an image with this content: #{yellow content}"
      body = {
          "instances": [
              {
                #"prompt": "Once upon a time, there was a young spy named Agent X. Agent X was the best spy in the world, and she was always on the lookout for new mysteries to solve. One day, Agent X was sent on a mission to investigate a mysterious cave at the bottom of a mountain."
                "prompt": content,
              }
          ],
          "parameters": {
              "sampleCount": 4,
              #"aspectRatio": "9:16",
              "aspectRatio": "1:1",
              "negativePrompt": "blurry",
          }
      }

      puts "BODY: '''#{body}'''" if opts_debug
      headers = {
          'Content-Type': 'application/json',
          'Authorization': "Bearer #{gcloud_access_token}"
      }
      response = Net::HTTP.post(uri, body.to_json, headers)
      # puts "Net::HTTP.post Response class: #{response.class}"
      # if response.class == Net::HTTPUnauthorized
      #   puts 'Looks like I got a 401 or similar not auth -> failing nicely'
      #   return response, nil
      # end
      if not response.class == Net::HTTPOK
        $stderr.puts "#{Story.emoji}.#{self.id}: Looks like I got a non-200 of some sort (#{response.class})-> failing nicely"
        return response, nil
      end

      puts('ai_curl_by_content(): response.inspect = ', response.inspect)

      json_body = JSON.parse(response.read_body)

      # next unless 200 :)
      my_one_file = nil

      #print("results: ", json_body['predictions'].size )
      prediction_size_minus_one = json_body['predictions'].size - 1 rescue 0
      if prediction_size_minus_one == 0
        puts "The system failed to generate this: #{red content}. Failing gracefully"
        return response, nil
      end
      #puts 'prediction_size_minus_one: ', prediction_size_minus_one
      (0..prediction_size_minus_one).each do |ix|
        # Self is probably the story.
        filename = "tmp/story.id=#{self.id rescue 'dunno'}.ix=#{ix}.png"

        mimeType = json_body['predictions'][ix]['mimeType']
        #puts("MIME[#{ix}]: #{mimeType}")    # shjould be PNG
        next unless mimeType == 'image/png' # shjould be PNG
        bytesBase64Encoded = json_body['predictions'][ix]['bytesBase64Encoded']
        puts("bytesBase64Encoded[#{ix}]: #{bytesBase64Encoded.size}B")

        File.open("#{filename}.b64enc", "w") {|f| f.write(bytesBase64Encoded)}
        File.open("#{filename}.b64dec", "w") {|f| f.write(Base64.decode64(bytesBase64Encoded)) rescue :fail}
        # https://stackoverflow.com/questions/16918602/how-to-base64-encode-image-in-linux-bash-shell
        File.open("#{filename}.b64dec2", "w") {|f| f.write(Base64.decode64(bytesBase64Encoded.each_byte.to_a.join)) rescue nil }

        # base64 -d t.base64 > "output/image-output-$IMAGE_IX.JPG"
        `base64 -d '#{filename}.b64enc' > '#{filename}'`
        #cat "$IMAGE_OUTPUT_PATH" | jq -r .predictions[$IMAGE_IX].bytesBase64Encoded > t.base64
        #IMAGE_IX
        ## https://stackoverflow.com/questions/61157933/how-to-attach-base64-image-to-active-storage-object

        #enc = Base64.encode64(bytesBase64Encoded.each_byte.to_a.join)
        #File.write("tmp123.png")
        #StringIO.new(Base64.decode64(params[:base_64_image].split(',')[1])),
        puts("Written file: #{filename}")
        file_mime_type = `file '#{filename}'`
        puts "file_mime_type: #{file_mime_type}"
        # story.id=74.ix=0.png.b64enc.shellato: PNG image data, 1024 x 1024, 8-bit/color RGB, non-interlaced
        my_one_file = filename if file_mime_type.match(/PNG image data/)
      end

      return response, my_one_file # redicted_content
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
