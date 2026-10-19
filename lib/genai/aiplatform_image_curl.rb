# Sample usage:
#    extend Genai::AiplatformImageCurl
#    ai_curl_images_by_content_v2('00X', 'blah blah blah poo', :mock => true )

module Genai
  # Only allow authenticated admins access to precious resources.
  module AiplatformImageCurl
    def correct_image_file_match(str)
      str.match(/PNG image data|JPEG image data/)
    end

    # This should be totally Entity independent and should return an IOStream imho... easy to attach.
    def decode_nth_base64_image_to_file(_model_version, filename, json_body, ix, _opts = {})
      opts_cleanup_after_yourself = _opts.fetch :cleanup_after_yourself, false

      puts "[DEB] decode_nth_base64_image_to_file(filename=#{filename}, ix=#{ix})"
      raise 'I need an integer for ix!' unless ix.is_a? Integer
      raise 'I need an hash for Opts!' unless _opts.is_a? Hash

      unless json_body.keys.include? 'predictions'
        puts("Failing - but before let me show you the answer: json_body=#{yellow json_body.to_s[0, 500]}")
        return nil
      end
      mimeType = json_body['predictions'][ix]['mimeType']
      raise "Wrong mime type: '#{mimeType}'" unless ['image/png', 'image/jpeg', 'image/webp'].include?(mimeType)

      bytesBase64Encoded = json_body['predictions'][ix]['bytesBase64Encoded']

      # Decode directly in Ruby (works on both macOS and Linux without external base64 flags)
      File.binwrite(filename, Base64.decode64(bytesBase64Encoded))

      if opts_cleanup_after_yourself && File.exist?("#{filename}.b64enc")
        File.delete("#{filename}.b64enc")
      end

      file_mime_type = `file '#{filename}'`.chomp
      puts("🖼️ Image[#{ix}]🖼️ EncSize: #{bytesBase64Encoded.size / 1024}KB #{file_mime_type}")

      my_one_file = filename if correct_image_file_match(file_mime_type)
    end

    # This function returns an array with two objects
    # 1. integer of success or error
    # 2. An array of images (if 0) or a hash of
    def ai_curl_images_by_content_v2(_model_version, content, opts = {})
      # options
      opts_debug = opts.fetch :debug, false
      opts_mock = opts.fetch :mock, false
      project_id = opts.fetch :project_id, AI_PROJECT_ID
      region = opts.fetch :region, 'us-central1'

      # Support legacy '001'/'002' callers by upgrading them to gemini-3.1-flash-image (Nano Banana 2)
      effective_model = case _model_version.to_s
                        when '001', '002', 'nano-banana', 'nano-banana-2', 'gemini-3.1-flash-image'
                          'gemini-3.1-flash-image'
                        else
                          _model_version.to_s
                        end

      json_body = nil
      ret_files = []
      ret_hash = {
        model_version: effective_model,
        is_mock: opts.fetch(:mock, 'absent')
      }

      # Cleanup content (formerly cleaned_up_content )
      content = cleaned_up_content(content)
      puts "🌃ImageGeneration🌃(#{effective_model}).content='#{yellow content}'"

      return 201, 'We are offline' if Genai::Common.network_offline?

      if opts_mock
        #######################
        # Mock authentication #
        #######################
        mock_version = _model_version.to_s.match?(/^(001|002)$/) ? _model_version : '002'
        mock_file = "#{Rails.root}/db/fixtures/APIs/publishers/google/models/imagegeneration:predict/image-output-#{mock_version}.json"
        puts "Now MOCK time, this should be super easy :) Reading: #{mock_file}"
        json_body = JSON.parse(File.read(mock_file))
        puts("Mock response: #{json_body}") if opts_debug
      else
        ########################
        # Real authentication (2026 Gemini 3.1 Flash Image / Nano Banana 2 via GEMINI_API_KEY, with Vertex AI 2.5 fallback)
        ########################
        prompt_text = "Generate a colorful, warm, high-quality children's storybook illustration (no text in image): #{content}"
        body = {
          "contents": [
            {
              "role": 'user',
              "parts": [
                { "text": prompt_text }
              ]
            }
          ]
        }
        puts "BODY: '''#{body}'''" if opts_debug

        gemini_api_key = opts.fetch(:gemini_api_key, ENV['GEMINI_API_KEY'])
        response = nil
        json_body = {}

        if gemini_api_key.to_s.strip.size > 10
          gl_url = "https://generativelanguage.googleapis.com/v1beta/models/#{effective_model}:generateContent?key=#{gemini_api_key.to_s.strip}"
          response = Net::HTTP.post(URI(gl_url), body.to_json, { 'Content-Type': 'application/json' })
          json_body = JSON.parse(response.read_body) rescue {}
        end

        unless json_body['candidates'].is_a?(Array)
          vertex_model = 'gemini-2.5-flash-image'
          gcloud_access_token = GCauth.instance.token
          ai_url = "https://#{region}-aiplatform.googleapis.com/v1/projects/#{project_id}/locations/#{region}/publishers/google/models/#{vertex_model}:generateContent"
          headers = {
            'Content-Type': 'application/json',
            'Authorization': "Bearer #{gcloud_access_token}"
          }
          response = Net::HTTP.post(URI(ai_url), body.to_json, headers)
          json_body = JSON.parse(response.read_body) rescue {}
        end

        # Normalize Gemini generateContent inlineData parts into predictions array for backwards compatibility
        if json_body['candidates'].is_a?(Array)
          predictions = []
          json_body['candidates'].each do |cand|
            parts = cand.dig('content', 'parts') || []
            parts.each do |part|
              inline = part['inlineData'] || part['inline_data']
              if inline && inline['data']
                predictions << {
                  'mimeType' => inline['mimeType'] || inline['mime_type'] || 'image/png',
                  'bytesBase64Encoded' => inline['data']
                }
              end
            end
          end
          json_body['predictions'] = predictions
          json_body['deployedModelId'] ||= (json_body['modelVersion'] || effective_model).to_s.gsub(/[^a-zA-Z0-9]/, '')
        end

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

        if response.instance_of?(Net::HTTPBadRequest) || json_body.key?('error')
          puts("XXX Error/HTTPBadRequest -> Showing the payload: #{json_body.to_s[0, 500]}")
          File.write('.tmp.HTTPBadRequest.json', json_body.to_json)
          error_message = begin
            json_body['error']['message']
          rescue StandardError
            nil
          end
          unless error_message.nil?
            warn "Error found! Error.status: #{red json_body['error']['status']}"
            warn "Error found! Error.Message: #{red error_message}"
            return [1, [], { error_status: json_body['error']['status'], error_message: error_message }]
          end
          return [
            1,
            [],
            { error_status: json_body.dig('error', 'status') }
          ]
        end
      end

      ########################################################################
      # Back to normal world. Either mock or not, here I have a response_json
      ########################################################################
      puts "Whether its mock or not, now json_body.keys=#{json_body.keys},  json_body.class=#{json_body.class}"
      puts "Response.deployedModelId: #{json_body['deployedModelId']}"

      my_one_file = nil

      print("results size: #{ json_body['predictions'].size rescue '?!?' }")

      prediction_size_minus_one = begin
        json_body['predictions'].size - 1
      rescue StandardError
        -1
      end

      if prediction_size_minus_one < 0
        puts 'The system returned 200 but it failed to generate anything: Failing gracefully.'
        puts "response: #{response}"
        return [420, [], { error_status: 'Size is 0' }]
      end

      (0..prediction_size_minus_one).each do |ix|
        dmi = (json_body['deployedModelId'] || '2026').to_s.gsub(/[^a-zA-Z0-9]/, '')
        filename = "tmp_#{_model_version}-#{content.gsub(/ /, '_').gsub(/[^a-zA-Z0-9_]/, '')[0, 90]}.ix=#{ix}.dmi=#{dmi}.png"

        decode_nth_base64_image_to_file(_model_version, filename, json_body, ix, opts)

        if File.exist?(filename) and correct_image_file_match(`file '#{filename}'`.chomp)
          puts "File exists and matches: #{filename}"
          my_one_file = filename
          ret_files << filename
        end
        ret_hash["#{ix}_my_one_file"] = my_one_file
      end

      [0, ret_files, ret_hash]
    end
  end
end
