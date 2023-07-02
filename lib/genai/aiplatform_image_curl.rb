# Sample usage:
#    extend Genai::AiplatformImageCurl
#    ai_curl_images_by_content_v2('001', 'blah blah blah poo', :mock => true )

module Genai
  # Only allow authenticated admins access to precious resources.
  module AiplatformImageCurl
    def correct_image_file_match(str)
      str.match(/PNG image data|JPEG image data/)
    end

    # This should be totally Enity independent and should return an IOStream imho... easy to attach.
    def decode_nth_base64_image_to_file(_model_version, filename, json_body, ix, _opts = {})
      opts_cleanup_after_yourself = _opts.fetch :cleanup_after_yourself, false
      # filename = "#{ix}_#{filename}"
      puts "[DEB] decode_nth_base64_image_to_file(filename=#{filename}, ix=#{ix})"
      # raise 'I need a Story !' unless story.is_a? Story
      raise 'I need an integer for ix!' unless ix.is_a? Integer
      raise 'I need an hash for Opts!' unless _opts.is_a? Hash

      unless json_body.keys.include? 'predictions'
        puts("Failing - but before let me show you the answer: #{json_body}")
        # ret_hash[:ret_message] = 'Empty body w/ no predictions'
        return nil # [0, [], ret_hash]
      end
      mimeType = json_body['predictions'][ix]['mimeType']
      # puts("MIME[#{ix}]: #{mimeType}")    # shjould be PNG
      raise "Wrong mime type: '#{mimeType}'" unless ['image/png', 'image/jpeg'].include?(mimeType)

      bytesBase64Encoded = json_body['predictions'][ix]['bytesBase64Encoded']

      # This is needed fot then creating the designated file :)
      File.open("#{filename}.b64enc", 'w') { |f| f.write(bytesBase64Encoded) }

      # https://stackoverflow.com/questions/16918602/how-to-base64-encode-image-in-linux-bash-shell
      encode_file = if `uname`.chomp == 'Darwin'
                      `base64 -i '#{filename}.b64enc' -d > '#{filename}'`
                    else
                      `base64 -d '#{filename}.b64enc' > '#{filename}'`
                    end # Linux

      if opts_cleanup_after_yourself
        puts 'Lets cleanup the b64enc now that the file has been decoded and created..'
        File.delete("#{filename}.b64enc")
      end

      # encode_file_on_mac_or_linux = todo
      # encode_file_on_linux = `base64 -d '#{filename}.b64enc' > '#{filename}'`
      # encode_file_on_mac =
      #      encode_file_on_mac = `openssl base64 -d -in '#{filename}.b64enc' -out '#{filename}'`
      #
      # puts "encode_file (on #{`uname`.chomp}): #{encode_file}"

      # cat "$IMAGE_OUTPUT_PATH" | jq -r .predictions[$IMAGE_IX].bytesBase64Encoded > t.base64
      # IMAGE_IX
      ## https://stackoverflow.com/questions/61157933/how-to-attach-base64-image-to-active-storage-object

      # enc = Base64.encode64(bytesBase64Encoded.each_byte.to_a.join)
      # File.write("tmp123.png")
      # StringIO.new(Base64.decode64(params[:base_64_image].split(',')[1])),
      # puts("Written file: #{filename}")
      file_mime_type = `file '#{filename}'`.chomp
      puts("🖼️ Image[#{ix}]🖼️ EncSize: #{bytesBase64Encoded.size / 1024}KB #{file_mime_type}") # filename AND mimetype

      # story.id=74.ix=0.png.b64enc.shellato: PNG image data, 1024 x 1024, 8-bit/color RGB, non-interlaced
      my_one_file = filename if correct_image_file_match(file_mime_type) #
    end

    # This function returns an array with two objects
    # 1. integer of success or error
    # 2. An array of images (if 0) or a hash of
    def ai_curl_images_by_content_v2(_model_version, content, opts = {})
      # options
      opts_debug = opts.fetch :debug, false
      opts_mock = opts.fetch :mock, false
      project_id = opts.fetch :project_id, PROJECT_ID
      region = opts.fetch :region, 'us-central1'

      raise 'unsupported model' unless _model_version.match(/^(001|002)$/)

      json_body = nil
      ret_files = []
      ret_hash = {
        model_version: _model_version,
        is_mock: opts.fetch(:mock, 'absent')
        # response_ok: response.instance_of?(Net::HTTPOK),
        # http_response_code: response.respond_to?(:code) ? response.code : nil,
        # ret_message: response.nil? ? 'Empty response' : 'All good'
      }

      puts "🌃ImageGeneration🌃(v#{_model_version}).content='#{yellow content}'"

      puts '''TODO ricc:
            3. Test the attach file as part of this, maybe as a callback or an opts object which is of type
         attachable
      '''

      if opts_mock
        #######################
        # Mock authentication #
        #######################
        mock_file = "#{Rails.root}/db/fixtures/APIs/publishers/google/models/imagegeneration:predict/image-output-#{_model_version}.json"
        puts "Now MOCK time, this should be super easy :) Reading: #{mock_file}"
        json_body = JSON.parse(File.read(mock_file))
        puts("Mock response: #{json_body}") if opts_debug
      else
        ########################
        # Real authentication
        ########################

        # puts "Riccardo copia quel che c'e' dopo"
        gcloud_access_token = GCauth.instance.token # opts.fetch :gcloud_access_token, GCLOUD_ACCESS_TOKEN
        ai_url = "https://us-central1-aiplatform.googleapis.com/v1/projects/#{project_id}/locations/us-central1/publishers/google/models/imagegeneration@#{_model_version}:predict"
        # puts("ai_url: #{ai_url}") if opts_debug
        uri = URI(ai_url)
        puts("uri:    #{uri}") if opts_debug
        # puts "#{Story.emoji} Story.#{id}. Generating an image with this content: #{yellow content}"
        body = {
          "instances": [
            {
              "prompt": content
            }
          ],
          "parameters": {
            "sampleCount": 8, # 8 is max :)
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

        json_body = JSON.parse(response.read_body) # rescue nil

        ret_hash[:response_ok] = response.instance_of?(Net::HTTPOK)
        ret_hash[:http_response_code] = response.respond_to?(:code) ? response.code : nil
        ret_hash[:ret_message] = response.nil? ? 'Empty response' : 'All good'
        ret_hash[:deployedModelId] = json_body['deployedModelId']
        ret_hash[:number_of_images_returned] = begin
          json_body['predictions'].size
        rescue StandardError
          'No Predictions'
        end
        ret_hash[:error_status] = begin
          json_body['error']['status']
        rescue StandardError
          nil
        end

        if response.instance_of?(Net::HTTPBadRequest)
          puts("XXX HTTPBadRequest -> Showing the payload: size=#{json_body.size}")
          File.write('.tmp.HTTPBadRequest.json', json_body)
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
          #          return [1, json_body]
          return [
            1,
            [],
            { error_status: json_body['error']['status'] }
          ]
        end
      end

      ########################################################################
      # Back to normal world. Either mock or not, here I jhave a response_json
      ########################################################################
      puts "Whether its mock or not, now json_body.keys=#{json_body.keys},  json_body.class=#{json_body.class}"
      puts "Response.deployedModelId: #{json_body['deployedModelId']}"

      # next unless 200 :)
      my_one_file = nil

      # print("results: ", json_body['predictions'].size )
      prediction_size_minus_one = begin
        json_body['predictions'].size - 1
      rescue StandardError
        0
      end
      if prediction_size_minus_one < 0
        # puts "#{Story.emoji}.#{id} The system returned 200 but it failed to generate this: #{red content}. Failing gracefully. But let me show you the payload first"
        puts 'The system returned 200 but it failed to generate anything: Failing gracefully. But let me show you the payload first'
        puts "response: #{response}"
        #        puts "json_body: #{json_body}"
        return 420, 'Size is 0' # nil
      end
      # puts 'prediction_size_minus_one: ', prediction_size_minus_one
      (0..prediction_size_minus_one).each do |ix|
        # ret_hash["#{ix}_start"] = 'debug'
        filename = "tmp_#{_model_version}-#{content.gsub(/ /, '_')}.ix=#{ix}.png"

        file = decode_nth_base64_image_to_file(_model_version, filename, json_body, ix, opts)

        if File.exist?(filename) and correct_image_file_match(`file '#{filename}'`.chomp) # .match(/PNG image data/)
          my_one_file = filename
          ret_files << filename
        end
        # puts "my_one_file[#{ix}] AFTER: #{my_one_file}"
        ret_hash["#{ix}_my_one_file"] = my_one_file
        # ret_hash["#{ix}_file_exist"] = File.exist?(filename)
        # ret_hash["#{ix}_correct_image_file_match"] = correct_image_file_match(`file '#{filename}'`.chomp)
      end

      [0, ret_files, ret_hash] # redicted_content
    end
  end
end
