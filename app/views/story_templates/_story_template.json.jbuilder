json.extract! story_template, :id, :short_code, :description, :template, :internal_notes, :user_id, :created_at, :updated_at
json.url story_template_url(story_template, format: :json)
