# A story is composed of N paragraphs
# #
# StoryParagraph(id: integer, story_index: integer, original_text: text, genai_input_for_image: text, internal_notes: text, translated_text: text, language: string, story_id: integer, rating: integer, created_at: datetime, updated_at: datetime)
class StoryParagraph < ApplicationRecord
  belongs_to :story

  validates :story_index, uniqueness: { scope: :story_id }
  validates :story_index, numericality: { in: 1..100 }
  validates :rating, numericality: { in: 1..5 }, allow_nil: true
  validates :language, presence: true,
                       format: { with: /\A(it|es|pt|de|en|ru|jp)\z/i, message: 'We only support ITalian, Spanish, portuguese, german, english, Russian and Japanese now. Exactly, all my colleagues are 🇫🇷 :)' }

  after_create :after_creation_magic

  def after_creation_magic
    puts '1 [DELAYED] if translation  is nil but we have original text AND language => trigger GTranslate (DELAY)'
    puts '2 [NOW] if video text not available -> generate it determiniistically (now)'
    puts '3 [DELAYED] if video text available -> generate image '
  end

  def flag
    # case language
    # when 'it': '🇫🇷'
    # end
    case language
    when 'it'
      '🍕'
    when 'fr'
      '🇫🇷'
    when 'jp'
      '🇯🇵'
    when 'de'
      '🇩🇪'
    when 'es'
      '🇦🇷'
    when 'pt'
      '🇧🇷'

    # when 'foo', 'bar'
    #   "It's either foo or bar"
    # when String
    #   'You passed a string'
    else
      "You gave me #{x} -- I have no idea what to do with that."
    end
  end

  def self.emoji
    '📜'
  end
end
