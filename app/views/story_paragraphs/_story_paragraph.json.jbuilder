json.extract! story_paragraph, :id, :story_index, :original_text, :genai_input_for_image, :internal_notes,
              :translated_text, :language, :story_id, :translated_story_id, :rating, :created_at, :updated_at
json.url story_paragraph_url(story_paragraph, format: :json)
