json.extract! story, :id, :title, :genai_input, :genai_output, :genai_summary, :internal_notes, :user_id, :kid_id, :cover_image, :created_at, :updated_at
json.url story_url(story, format: :json)
json.cover_image url_for(story.cover_image)
