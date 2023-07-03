def yellow(s)
  "\033[1;33m#{s}\033[0m"
end

def white(s)
  "\033[1;33m#{s}\033[0m"
end

def blue(s)
  "\033[1;33m#{s}\033[0m"
end

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
    '🇦🇷'
  when 'pt'
    '🇧🇷'
  when 'ru'
    '🇷🇺'
  else
    "You gave me lang='#{language}' -- I have no idea what to do with that."
  end
end
