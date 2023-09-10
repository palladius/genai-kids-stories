# https://cloud.google.com/ruby/docs/reference/google-cloud-text_to_speech-v1/latest/index.html

# GITHUB: https://github.com/googleapis/google-cloud-ruby/blob/main/google-cloud-text_to_speech/README.md
#
ENV['GOOGLE_AUTH_SUPPRESS_CREDENTIALS_WARNINGS'] = 'true'

require "google/cloud/text_to_speech/v1"
require "base64"
require 'json'



def synthesize_speech(str, lang='en-gb', opts={})
  opts_debug= opts.fetch :debug, true # todo false

  # gaelic is not supported!
#  lang = 'it' if lang == 'ga' and opts_debug
  return false if lang == 'ga'


  filename = "tmp-speech.mp3"
  puts("🎶 synthesize_speech(str='#{str}', lang='#{lang}') being called..")


  request_hash = {
    input: {
      text: str,
      # "Riccardo is a mobile operating system developed by Google, based on the Linux kernel and designed primarily for touchscreen mobile devices such as smartphones and tablets."
    },
    'voice': {
      # TOSO iso_language_code
      language_code: iso_language_code(lang), # "en-gb",
      #name: "en-GB-Standard-A",
      ssml_gender: "FEMALE"
    },
    audio_config:{
      audio_encoding: "MP3"
    }
  }

  # Create a client object. The client can be reused for multiple calls.
  client = Google::Cloud::TextToSpeech::V1::TextToSpeech::Client.new

  # Create a request. To set request fields, pass in keyword arguments.
  request = Google::Cloud::TextToSpeech::V1::SynthesizeSpeechRequest.new(request_hash)

  puts(request_hash) if opts_debug

  # Call the synthesize_speech method.
  # Can yield this error: 3:Voice '' does not exist. Is it misspelled?. debug_error_string:{UNKNOWN:Error received from peer ipv6:%5B2a00:1450:400a:808::200a%5D:443 {created_time:"2023-09-07T07:48:20.653732+02:00", grpc_status:3, grpc_message:"Voice \'\' does not exist. Is it misspelled?"}}
  result = client.synthesize_speech request

  # The returned object is of type Google::Cloud::TextToSpeech::V1::SynthesizeSpeechResponse.

  # todo cleanup this...
  result_hash = result.to_h
  result_json = result.to_json

  if result_hash.keys.include? :audio_content
    p :HABEUMS_RESPOSTAM
    # encoded_audio_content = result_hash[:audio_content] # DOESNT WORK!
    encoded_audio_content = JSON.parse(result_json)['audioContent']
    decoded_audio_content = Base64.decode64(encoded_audio_content.gsub("\r", ''))
    puts "decoded_audio_content size: #{decoded_audio_content.size}"
    File.open(filename, "wb") do |f|
      f.write(decoded_audio_content)
    end
    puts 'Written correctly file.. Debug info to make sure its good stuff'
    puts "TODO(ricc): pass directly the file content so ActiveStorage slurps it "
    puts `ls -alh #{filename}`
    puts `file #{filename}`
    return filename
  else
    puts "No response received."
    return nil
  end
end


#synthesize_speech()
