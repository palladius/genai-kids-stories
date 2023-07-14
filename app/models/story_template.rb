# create_table "story_templates", force: :cascade do |t|
#     t.string "short_code"
#     t.string "description"
#     t.text "template"
#     t.text "internal_notes"
#     t.integer "user_id"
# end

class StoryTemplate < ApplicationRecord
    validates :short_code, uniqueness: true,  presence: true # short index
    validates :description, uniqueness: true,  presence: true # long index
    validates :short_code, presence: true,
        format: { with: /\A([a-z_-]+)\z/, message: 'No spaces, just dash underscores and lower cases' }



        def instanciate
            'TODO(Rocc): the idea is to take the template and apply random or deterministic functions to the {parts}...'
        end

        def to_s
            "STmpl(#{id}): '#{short_code}' #{validity_emoji}.."
        end


    end

