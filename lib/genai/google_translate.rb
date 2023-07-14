require 'google/cloud/translate/v2'

#

# gem 'google-cloud-translate'
# exanple: https://github.com/googleapis/google-cloud-ruby/blob/main/google-cloud-translate/lib/google/cloud/translate/helpers.rb
def google_translate(_body, _language = 'it', _gtranslate_key = nil)
  require 'google/cloud/translate/v2'
  key_i_use = _gtranslate_key.nil? ? GOOGLE_TRANSLATE_KEY2 : _gtranslate_key

  return "[🚠OFFLINE] #{_body}" if Genai::Common.network_offline?
  raise 'No/small Key! ' if key_i_use.to_s.size < 10

  # puts("DEB google_translate().key='#{key_i_use.to_s.first(5)}'..")

  begin
    translate_request = Google::Cloud::Translate::V2.new(key: key_i_use)
    translation_response = translate_request.translate(_body, to: _language)
  rescue StandardError
    # flash.alert =
    logger.error("Google Translate error: #{$!}")
    return ''
  end

  # translation_response.text #=> "Salve mundi!"

  # Removing the 's and "s
  translated_string = translation_response.text.gsub('&#39;', "'").gsub('&quot;', '"')
  puts("DEB Translate returned: #{yellow translated_string}")
  translated_string
end

# translate('yesterday i fell off a cliff and broke a knee. Today im fine')
# require 'easy_translate'
# GOOGLE_TRANSLATE_KEY ||= ENV.fetch('GOOGLE_TRANSLATE_KEY', :blah)
# EasyTranslate.api_key = GOOGLE_TRANSLATE_KEY

# def translate(_body, _language)
#   EasyTranslate.translate('Hello, world', to: :spanish) # => "Hola, mundo"
#   EasyTranslate.translate('Hello, world', to: 'es', key: ENV.fetch('GOOGLE_TRANSLATE_KEY', :blah)) # => "Hola, mundo"
# end
