json.extract! kid, :id, :name, :surname, :nick, :visual_description, :is_male, :date_of_birth, :internal_info,
              :user_id, :avatar, :favorite_language, :active, :created_at, :updated_at
json.url kid_url(kid, format: :json)
