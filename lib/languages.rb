AVAIL_LANGUAGES = %w[it de es fr ko ja pt ru zh].sort.freeze
AVAIL_LANGUAGE_REGEX = /\A(it|es|fr|pt|de|en|ru|ja|zh)\z/i

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
    '🇪🇸' # '🇦🇷'
  when 'ko'
    '🇰🇷'
  when 'pt'
    '🇧🇷'
  when 'ru'
    '🇷🇺'
  when 'zh' # Simplified chinese: https://cloud.google.com/translate/docs/languages
    '🇨🇳' # chinese flag '🇨🇳'
  else
    "You gave me lang='#{language}' -- I have no idea what to do with that."
  end
end
