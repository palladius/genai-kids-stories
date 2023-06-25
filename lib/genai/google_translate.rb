require 'google/cloud/translate/v2'

# gem 'google-cloud-translate'
# exanple: https://github.com/googleapis/google-cloud-ruby/blob/main/google-cloud-translate/lib/google/cloud/translate/helpers.rb
def google_translate(_body, _language = 'it', _gtranslate_key = nil)
  require 'google/cloud/translate/v2'
  # puts "|GOOGLE_TRANSLATE_KEY: #{GOOGLE_TRANSLATE_KEY}"
  # puts "|GOOGLE_TRANSLATE_KEY2: #{GOOGLE_TRANSLATE_KEY2}"
  # key_i_use = GOOGLE_TRANSLATE_KEY2
  key_i_use = _gtranslate_key.nil? ? GOOGLE_TRANSLATE_KEY2 : _gtranslate_key

  raise 'No/small Key! ' if key_i_use.to_s.size < 10

  puts("DEB google_translate().key='#{key_i_use.to_s.first(5)}'..")
  translate = Google::Cloud::Translate::V2.new(
    # NOTE: should be viceversa: first argument, then ENV.
    key: key_i_use # ENV.fetch('GOOGLE_TRANSLATE_KEY', _gtranslate_key)
  )
  translation = translate.translate _body, to: _language
  # translation.text #=> "Salve mundi!"

  # Removing the 's and "s
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
