# create_table "story_templates", force: :cascade do |t|
#     t.string "short_code"
#     t.string "description"
#     t.text "template"
#     t.text "internal_notes"
#     t.integer "user_id"
# end

class StoryTemplate < ApplicationRecord
    include TemplateSubstitutable

    validates :short_code, uniqueness: true,  presence: true # short index
    validates :description, uniqueness: true,  presence: true # long index
    validates :short_code, presence: true,
        format: { with: /\A([a-z_-]+)\z/, message: 'No spaces, just dash underscores and lower cases' }


    #kid_description = opts.fetch :kid_description, 'A blue-eyed afroamerican 6-year-old red-haired girl called Foobar Baz' # if kid_description.nil?
      #character = opts.fetch :character, pickARandomElementOf(CHARACTERS) #   if character.nil?
      #setting = opts.fetch :setting, pickARandomElementOf(SETTINGS) #  if setting.nil?
      #plot = opts.fetch :plot, pickARandomElementOf(PLOTS) #  if plot.nil?


        def instanciate
            ' TODO(ricc): the idea is to take the template and apply random or deterministic functions to the {parts}...'
            instanciated_template = self.template
            parts2bChanged = instanciated_template.scan(/{{[a-z]+}}/)
            parts2bChanged.each do |x|
                instanciated_template = substitute_var(x, instanciated_template)
#                case my_var
#                    when 'character': instanciated_template =
            end

            "👢 instanciate(WIP): #{yellow instanciated_template}"
        end

        def to_s
            "STmpl(#{id}): '#{short_code}' #{validity_emoji}.."
        end

        def self.emoji
            '📋'
        end


    end

