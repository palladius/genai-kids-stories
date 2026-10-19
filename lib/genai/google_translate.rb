require 'google/cloud/translate/v2'

#

# gem 'google-cloud-translate'
# exanple: https://github.com/googleapis/google-cloud-ruby/blob/main/google-cloud-translate/lib/google/cloud/translate/helpers.rb
def google_translate(_body, _language = 'it', _gtranslate_key = nil)
  require 'google/cloud/translate/v2'
  key_i_use = _gtranslate_key.nil? ? (GOOGLE_TRANSLATE_KEY2 || GOOGLE_TRANSLATE_KEY) : _gtranslate_key

  return "[🚠OFFLINE] #{_body}" if Genai::Common.network_offline?

  if key_i_use.to_s.size >= 10
    begin
      translate_request = Google::Cloud::Translate::V2.new(key: key_i_use)
      translation_response = translate_request.translate(_body, to: _language)
      translated_string = translation_response.text.gsub('&#39;', "'").gsub('&quot;', '"')
      puts("DEB Translate V2 returned: #{yellow translated_string}")
      return translated_string if translated_string.to_s.strip.size > 0
    rescue StandardError => e
      warn("Google Translate V2 error (#{e.message}), falling back to Gemini 2.5 Flash...")
    end
  end

  # Fallback to Gemini 2.5 Flash translation
  begin
    helper = Object.new.extend(Genai::AiplatformTextCurl)
    _resp, gemini_translation = helper.ai_curl_by_content(
      "Translate the following children's story text into language code '#{_language}'. Return ONLY the translated text, preserving any markdown formatting like **Act 1**:\n\n#{_body}"
    )
    return gemini_translation.to_s.strip if gemini_translation.to_s.strip.size > 0
  rescue StandardError => e
    warn("Gemini translation fallback error: #{e.message}")
  end

  _body.to_s
end

# translate('yesterday i fell off a cliff and broke a knee. Today im fine')
# require 'easy_translate'
# GOOGLE_TRANSLATE_KEY ||= ENV.fetch('GOOGLE_TRANSLATE_KEY', :blah)
# EasyTranslate.api_key = GOOGLE_TRANSLATE_KEY

# def translate(_body, _language)
#   EasyTranslate.translate('Hello, world', to: :spanish) # => "Hola, mundo"
#   EasyTranslate.translate('Hello, world', to: 'es', key: ENV.fetch('GOOGLE_TRANSLATE_KEY', :blah)) # => "Hola, mundo"
# end
