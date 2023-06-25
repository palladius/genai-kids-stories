# A story is composed of N paragraphs

# # MODEL
# StoryParagraph(id: integer,
#    story_index: integer,
#    original_text: text,
#    genai_input_for_image: text,
#    internal_notes: text,
#    translated_text: text,
#    language: string,
#    story_id: integer,
#    rating: integer,
#    created_at: datetime,
#    updated_at: datetime)
#
# # POLYMORPHIC
# p_images (many)
# p_image1 (one)
# p_image2 (one)
# p_image3 (one)
# p_image4 (one)
class StoryParagraph < ApplicationRecord
  include AiImageable
  belongs_to :story

  validates :story_index, uniqueness: { scope: :story_id }
  validates :story_index, numericality: { in: 1..100 }
  validates :rating, numericality: { in: 1..5 }, allow_nil: true
  validates :language, presence: true,
                       format: { with: /\A(it|es|pt|de|en|ru|jp)\z/i, message: 'We only support ITalian, Spanish, portuguese, german, english, Russian and Japanese now. Exactly, all my colleagues are 🇫🇷 :)' }

  # image attachments. Not sure whether to force 4 or ahev any. 4 would be easy for frontend (square with 4)
  has_many_attached :p_images # , service: :google

  has_one_attached :p_image1 # , service: :google
  has_one_attached :p_image2 # , service: :google
  has_one_attached :p_image3 # , service: :google
  has_one_attached :p_image4 # , service: :google

  # PROD
  after_create :after_creation_magic
  # DEV: easier to debug
  # after_save :after_creation_magic
  # after_save :after_creation_delayed_magic

  def after_creation_delayed_magic
    delay.after_creation_magic
  end

  def after_creation_magic
    puts '1 [DELAYED] if translation  is nil but we have original text AND language => trigger GTranslate (DELAY)'
    write_translated_content_for_paragraph if translated_text.to_s.length < 5
    puts '2 [NOW] if picture text not available -> generate it determiniistically (now)'
    generate_genai_text_for_paragraph if genai_input_for_image.to_s.length < 10 # genai_input_for_image.nil?
    puts '3 [DELAYED] if video text available -> generate image '
    generate_one_genai_image_from_image_description! if genai_input_for_image.to_s.length > 20
  end

  def flag
    # case language
    # when 'it': '🇫🇷'
    # end
    case language
    when 'it'
      '🇮🇹'
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
    when 'ru'
      '🇷🇺'

    # when 'foo', 'bar'
    #   "It's either foo or bar"
    # when String
    #   'You passed a string'
    else
      "You gave me #{language} -- I have no idea what to do with that."
    end
  end

  def self.available_lanugages
    %w[it es jp ru de pt].sort
  end

  def self.emoji
    '📜'
  end

  def write_translated_content_for_paragraph(_opts = {})
    self.translated_text = google_translate(original_text, language) # language
    save
  end

  def generate_genai_text_for_paragraph(_opts = {})
    puts 'generate_genai_text_for_paragraph(): START'
    kid = story.kid
    my_style = _opts.fetch :style, 'Pixar'

    self.genai_input_for_image = "Imagine a #{kid.visual_description}. Beside #{kid.akkusativ}, #{original_text}, in the style of #{my_style}"
    puts "Proposed genai_input_for_image for SP.#{id}: #{yellow genai_input_for_image}"
    ret = save
    if ret
      puts 'SAVE OK!'
    else
      puts "SAVE ERROR: #{errors.full_messages}"
    end
  end

  # rails c >  StoryParagraph.first.generate_genai_image_from_image_description
end
