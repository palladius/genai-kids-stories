json.extract! translated_story, :id, :name, :user_id, :story_id, :language, :kid_id, :paragraph_strategy,
              :internal_notes, :genai_model, :created_at, :updated_at
json.url translated_story_url(translated_story, format: :json)
