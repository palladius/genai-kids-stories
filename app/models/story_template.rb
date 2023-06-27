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

end
