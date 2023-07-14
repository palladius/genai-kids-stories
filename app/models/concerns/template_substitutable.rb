module TemplateSubstitutable
  extend ActiveSupport::Concern

  # kid_description = opts.fetch :kid_description, 'A blue-eyed afroamerican 6-year-old red-haired girl called Foobar Baz' # if kid_description.nil?
  # character = opts.fetch :character, pickARandomElementOf(CHARACTERS) #   if character.nil?
  # setting = opts.fetch :setting, pickARandomElementOf(SETTINGS) #  if setting.nil?
  # plot = opts.fetch :plot, pickARandomElementOf(PLOTS) #

    def substitute_var(parenthesized_var, old_value)
      #extend Genai::AiplatformTextCurl

      #puts "Parenthesized Var to instanciate: '#{var}'"
      short_var = parenthesized_var.gsub(/[{}]/,'') # {{blah}} -> blah
      # Now I'll call a callback function depending on the name :)
      string_val = case short_var
      when 'character'
        Genai::AiplatformTextCurl::CHARACTERS.sample
      when 'plot'
        Genai::AiplatformTextCurl::PLOTS.sample
      when 'setting'
        Genai::AiplatformTextCurl::SETTINGS.sample
      else
        raise "dont know how to translate this: #{short_var}"
      end
      return old_value.gsub(parenthesized_var, string_val)
    end



end
