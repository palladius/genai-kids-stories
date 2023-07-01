# Sample usage:
#    extend Genai::AiplatformImageCurl
#    ai_curl_images_by_content_v2('001', 'blah blah blah poo', :mock => true )

module Genai
  # Only allow authenticated admins access to precious resources.
  module AiplatformImageCurl
    # This function returns an array with two objects
    # 1. integer of success or error
    # 2. An array of images (if 0) or a hash of
    def ai_curl_images_by_content_v2(_model_version, content, opts = {})
      # options
      opts_debug = opts.fetch 'DEBUG', false
      opts_mock = opts.fetch :mock, true # TODO: false
      puts '''
      1. No trace of business logic here, no Objects/classes from Kids.
      2. Have a mock option. if true, picks up from a static file to save 15sec in troubleshooting phase
      3. Test the attach file as part of this, maybe as a callback or an opts object which is of type
         attachable
      '''
      raise 'unsupported model' unless _model_version.match(/^(001|002)$/)

      if opts_mock
        puts 'Now MOCK time, this should be super easy :)'
        response_json = File.read("#{Rails.root}/db/fixtures/APIs/publishers/google/models/imagegeneration:predict/image-output-#{_model_version}.json")
        puts response_json
        exit 1
      else
        # copia il dopo
        puts "Riccardo copia quel che c'e' dopo"
        raise 'TODO merge mock with no mock'
      end

      # filling empty values
      project_id = opts.fetch :project_id, PROJECT_ID
      gcloud_access_token = opts.fetch :gcloud_access_token, GCLOUD_ACCESS_TOKEN
      model_id = opts.fetch :model_id, MODEL_ID
      region = opts.fetch :region, 'us-central1'

      # ai_url = "https://us-central1-aiplatform.googleapis.com/v1/projects/#{project_id}/locations/us-central1/publishers/google/models/imagegeneration:predict"
      ai_url = "https://us-central1-aiplatform.googleapis.com/v1/projects/#{project_id}/locations/us-central1/publishers/google/models/imagegeneration@002:predict"
      puts("ai_url: #{ai_url}") if opts_debug

      uri = URI(ai_url)
      puts("uri:    #{uri}") if opts_debug

      puts "#{Story.emoji} Story.#{id}. Generating an image with this content: #{yellow content}"
      body = {
        "instances": [
          {
            "prompt": content
          }
        ],
        "parameters": {
          "sampleCount": 8, # 8 is max :)
          # "aspectRatio": "9:16",
          "aspectRatio": '1:1',
          "negativePrompt": 'blurry'
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
      json_body = JSON.parse(response.read_body) # rescue nil

      if response.instance_of?(Net::HTTPBadRequest)
        puts("XXX HTTPBadRequest -> Showing the payload: size=#{json_body.size}")
        File.write(".story-#{id}.HTTPBadRequest.json", json_body)
        ## {"error"=>{"code"=>400, "message"=>"Image generation failed with the following error: The response is blocked, as it may violate our policies. If you believe this is an error, please send feedback to your account team.", "status"=>"INVALID_ARGUMENT", "details"=>[{"@type"=>"type.googleapis.com/google.rpc.DebugInfo", "detail"=>"[ORIGINAL ERROR] generic::invalid_argument: Image generation failed with the following error: The response is blocked, as it may violate our policies. If you believe this is an error, please send feedback to your account team. [google.rpc.error_details_ext] { message: \"Image generation failed with the following error: The response is blocked, as it may violate our policies. If you believe this is an error, please send feedback to your account team.\" }"}]}}
        error_message = begin
          json_body['error']['message']
        rescue StandardError
          nil
        end
        unless error_message.nil?
          warn "Error found! Error.status: #{red json_body['error']['status']}"
          warn "Error found! Error.Message: #{red error_message}"
          return error_message, nil
        end
        return response, nil
      end

      unless response.instance_of?(Net::HTTPOK)
        warn "#{Story.emoji}.#{id}: Looks like I got a non-200 of some sort (#{red response.class}) -> failing nicely"
        return response, nil
      end

      puts("ai_curl_by_content(): response.class:#{response.class} response.inspect=#{response.inspect}")

      # next unless 200 :)
      my_one_file = nil

      # print("results: ", json_body['predictions'].size )
      prediction_size_minus_one = begin
        json_body['predictions'].size - 1
      rescue StandardError
        0
      end
      if prediction_size_minus_one == 0
        puts "#{Story.emoji}.#{id} The system returned 200 but it failed to generate this: #{red content}. Failing gracefully. But let me show you the payload first"
        puts "response: #{response}"
        puts "json_body: #{red json_body}"
        return response, json_body # nil
      end
      # puts 'prediction_size_minus_one: ', prediction_size_minus_one
      (0..prediction_size_minus_one).each do |ix|
        # puts "my_one_file[#{ix}] BEFORE: #{my_one_file}"
        if is_a?(Story)
          filename = _convert_base64_image_to_file(self, 'story', json_body, ix)
        elsif is_a?(StoryParagraph)
          filename = _convert_base64_image_to_file(story, 'story_paragraph', json_body, ix)
        end
        next if filename.nil?

        my_one_file = filename if File.exist?(filename) and `file '#{filename}'`.match(/PNG image data/)
        puts "my_one_file[#{ix}] AFTER: #{my_one_file}"
      end

      [response, my_one_file] # redicted_content
    end
  end
end
