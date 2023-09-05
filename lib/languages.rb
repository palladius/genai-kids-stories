AVAIL_LANGUAGES =       %w[de es fr ga it ja ko pt ru zh].sort.freeze
AVAIL_LANGUAGE_REGEX = /\A(de|es|fr|ga|it|ja|ko|pt|ru|zh)\z/i

AVAIL_LANGUAGE_MESSAGE = 'We only support Latin languages (IT ES FR PT), Gaelic, German, English, Korean, Russian and Japanese.'

# TODO: MOdule Language START

def waving_flag(language)
  case language
  when 'it'
    '🇮🇹'
  when 'fr'
    '🇫🇷'
  when 'ja'
    '🇯🇵'
  when 'de'
    '🇩🇪'
  when 'es'
    '🇪🇸' # Argentina: '🇦🇷'
  when 'ga'
    '🇮🇪' 
  when 'ko'
    '🇰🇷'
  when 'pt'
    '🇧🇷'
  when 'ru'
    '🇷🇺'
  when 'zh' # Simplified chinese: https://cloud.google.com/translate/docs/languages
    '🇨🇳' # chinese flag '🇨🇳'
  else
    "Unknown flag4lang='#{language}'"
  end
end
