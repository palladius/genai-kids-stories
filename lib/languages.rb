# TExt2speech supports fewer languages than Google Translate
# So we need to take the smallest set:
# https://cloud.google.com/text-to-speech/docs/voices
#
# TODO: DRY these two
AVAIL_LANGUAGES =       %w[de en es fr ga id it ja hi ko pl pt ru th tr vi zh].sort.freeze
AVAIL_LANGUAGE_REGEX = /\A(de|en|es|fr|ga|id|it|ja|hi|ko|pl|pt|ru|th|tr|vi|zh)\z/i

AVAIL_LANGUAGE_MESSAGE = 'We only support Latin languages (IT ES FR PT), Gaelic, German, English, Turkish, Russian, Japanese and a bunch of Asian languages. Wow.'


# TODO: MOdule Language START

def waving_flag(language)
  case language
    when 'fr'
      '🇫🇷'
    when 'ja'
      '🇯🇵'
    when 'de'
      '🇩🇪'
    when 'en'
      '🇬🇧'
    when 'es'
      '🇪🇸' # Argentina: '🇦🇷'
    when 'ga'
      '🇮🇪'
    when 'hi' # hindi
      '🇮🇳'
    when 'id' # indonesia
      '🇮🇩'
    when 'it'
      '🇮🇹'
    when 'ko'
      '🇰🇷'
    when 'pl'
      '🇵🇱'
    when 'pt'
      '🇧🇷'
    when 'ru'
      '🇷🇺'
    when 'th'
      '🇹🇭'
    when 'tr'
      '🇹🇷'
    when 'vi'
      '🇻🇳'
    when 'zh' # Simplified chinese: https://cloud.google.com/translate/docs/languages
      '🇨🇳' # chinese flag '🇨🇳'
    else
      "Unknown flag4lang='#{language}'"
  end
end

# https://www.andiamo.co.uk/resources/iso-language-codes/
# https://cloud.google.com/text-to-speech/docs/voices
def iso_language_code(language)
  case language
    when 'fr'
      'fr'
    when 'ja'
      'ja'
    when 'de'
      'de-ch' # :)
    when 'en'
      'en-gb'
    when 'es'
      'es' # Argentina: 'es-ar'
    when 'ga'
      'ga'
    when 'hi'
      'hi'
    when 'id'
      'id-ID'
    when 'it'
      'it'
    when 'ko'
      'ko'
    when 'pl'
      'pl-PL'
    when 'pt'
      'pt-BR'
    when 'ru'
      'ru'
    when 'th'
      'th-TH'
    when 'tr'
      'tr-TR'
    when 'vi'
      'vi-VN'
    when 'zh' # Simplified chinese: https://cloud.google.com/translate/docs/languages
      'zh-cn' # chinese flag '🇨🇳'
    else
      # https://www.andiamo.co.uk/resources/iso-language-codes/
      "Unknown ISO 639-1 code for '#{language}'"
    end
end
