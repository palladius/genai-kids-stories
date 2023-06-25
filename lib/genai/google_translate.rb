require 'google/cloud/translate/v2'

# gem 'google-cloud-translate'
# exanple: https://github.com/googleapis/google-cloud-ruby/blob/main/google-cloud-translate/lib/google/cloud/translate/helpers.rb
def google_translate(_body, _language = 'it', _gtranslate_key = nil)
  require 'google/cloud/translate/v2'
  translate = Google::Cloud::Translate::V2.new(
    # NOTE: should be viceversa: first argument, then ENV.
    key: GOOGLE_TRANSLATE_KEY # ENV.fetch('GOOGLE_TRANSLATE_KEY', _gtranslate_key)
  )
  translation = translate.translate _body, to: _language
  # translation.text #=> "Salve mundi!"
  translation.text.gsub('&#39;', "'").gsub('&quot;', '"')
end

# translate('yesterday i fell off a cliff and broke a knee. Today im fine')
# require 'easy_translate'
# GOOGLE_TRANSLATE_KEY ||= ENV.fetch('GOOGLE_TRANSLATE_KEY', :blah)
# EasyTranslate.api_key = GOOGLE_TRANSLATE_KEY

# def translate(_body, _language)
#   EasyTranslate.translate('Hello, world', to: :spanish) # => "Hola, mundo"
#   EasyTranslate.translate('Hello, world', to: 'es', key: ENV.fetch('GOOGLE_TRANSLATE_KEY', :blah)) # => "Hola, mundo"
# end