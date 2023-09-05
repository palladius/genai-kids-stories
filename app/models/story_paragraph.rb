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
# p_images (many)  Example which works: s.p_image1.attach(io: File.open('whiskers.png'), filename: :whiskers)
# p_image1 (one)
# p_image2 (one)
# p_image3 (one)
# p_image4 (one)
class StoryParagraph < ApplicationRecord
  include AiImageable
  # OLD
  belongs_to :story
  # NEW
  belongs_to :translated_story

  validates :story_index, uniqueness: { scope: %i[language story_id] }
  validates :story_index, numericality: { in: 1..1000 }
  validates :rating, numericality: { in: 1..5 }, allow_nil: true
  validates :language, presence: true,
                       format: { with: AVAIL_LANGUAGE_REGEX,
                                 message: 'We only support ITalian, Spanish, portuguese, german, english, Russian and Japanese now. Ok now also 🇫🇷 :)' }

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

  ## MAGIC thing
  def attach(_filename)
    attach!(_filename) unless p_image1.attached?
  end

  def attach!(_filename)
    # p_image1.attach(io: File.open(File.expand_path(_filename)), filename: _filename)
    attach_file_to_attachable_field(p_image1, _filename)
  end

  def attached?
    p_image1.attached?
  end

  def after_creation_delayed_magic
    delay(queue: 'story_paragrah::after_creation_magic').after_creation_magic
  end

  def after_creation_magic
    puts '1 [DELAYED] if translation  is nil but we have original text AND language => trigger GTranslate (DELAY)'
    write_translated_content_for_paragraph if translated_text.to_s.length < 5
    puts '2 [NOW] if picture text not available -> generate it determiniistically (now)'
    generate_genai_text_for_paragraph if genai_input_for_image.to_s.length < 10 # genai_input_for_image.nil?
    puts '3 [DELAYED] if video text available -> generate image '
    # generate_one_genai_image_from_image_description! if genai_input_for_image.to_s.length > 20
    generate_ai_images! if genai_input_for_image.to_s.length > 20 # && translated_story.primogenito?
  end

  def generate_ai_images!(gcp_opts = {})
    # puts 'TODO if multiple images then write MANY images :)'
    # genai_input_for_image
    if translated_story.primogenito?
      # first born: create them
      multiple_images = genai_compute_multiple_images_by_decription(p_images, genai_input_for_image, gcp_opts)
    else
      # I'm not the first born, I should copy images from it.
      puts 'TODO Not primogenito copy instead'
      copy_images_from_primogenito_sp
      # return 1040 # TODO: in carlessian numeric
      # copy_images_from(translated_story.primogenito)
    end
    # single_image = genai_compute_single_image_by_decription(p_image1, genai_input_for_image, gcp_opts)
  end

  def copy_images_from_primogenito_sp
    ts1 = translated_story.primogenito
    return :already if p_image1.attached?

    # bigbro has image, lets copy by story_index
    # story_ix1 = sp1.story_index
    # only ONE element. The TAKE transforms the relation in first elemnt:
    # https://stackoverflow.com/questions/12135745/what-is-the-fastest-way-to-find-the-first-record-in-rails-activerecord

    # ATTENTION I'm afraid its copying always the SAME image over and over, as if story_index is not working
    sp1 = StoryParagraph.where(story_index: story_index, story_id: story.id).take
    return :sp_not_found unless sp1.is_a?(StoryParagraph)

    # copy paro paro - https://stackoverflow.com/questions/54203886/how-to-copy-one-object-from-one-model-to-another-model-with-rails-activestorage
    puts("Saving image from primogenito SP.#{sp1.id} --> to this SP.#{id}")
    p_image1.attach(sp1.p_image1.blob) # attached_image === p_image1
    save
  end

  # Alias :)
  def fix
    copy_images_from_primogenito_sp unless translated_story.primogenito?
    after_creation_magic
    # not generate_ai_images!
  end

  def fix!
    generate_ai_images!
  end

  def flag
    waving_flag(language)
  end

  # TODO: fix typo
  def self.available_languages
    AVAIL_LANGUAGES
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
      puts 'generate_genai_text_for_paragraph() SAVE OK!'
    else
      puts "generate_genai_text_for_paragraph() SAVE ERROR: #{errors.full_messages}"
    end
  end

  def cleaned_up_translated_text
    translated_text.gsub(/\*\*(A[a-z]+ [12345])\*\*/, '<b class="story_act opacity-75" ><u>\1</b></u>').gsub('**',
                                                                                                             '').html_safe
  end

  def to_s
    "StoryParagraph.#{id} from Story(#{story_id}) and TransStory(#{translated_story_id})"
  end

end
