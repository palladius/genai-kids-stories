#
#   create_table "translated_stories", force: :cascade do |t|
# t.string "name" #  TODO translated title :)
# t.bigint "user_id", null: false
# t.bigint "story_id", null: false
# t.string "language"
# t.integer "kid_id"
# t.string "paragraph_strategy"
# t.text "internal_notes"
# t.string "genai_model"
# #
# # ADDED 'translated_title' recently
##
# t.index ["kid_id"], name: "index_translated_stories_on_kid_id"
# t.index ["story_id"], name: "index_translated_stories_on_story_id"
# t.index ["user_id"], name: "index_translated_stories_on_user_id"
# end

# This is something I should have created A LONG TIME AGO :)
class TranslatedStory < ApplicationRecord
  belongs_to :user # Oops its done in the DB, optional: true
  belongs_to :story
  belongs_to :kid, optional: true
  has_many :story_paragraphs

  # validates :language, presence: true # A TS needs a Story and a Language, STRONGLY.
  validates :language, presence: true,
                       format: { with: AVAIL_LANGUAGE_REGEX,
                                 message: 'We only support ITalian, Spanish, portuguese, german, english, Russian and Japanese now. Ok now also 🇫🇷 :)' }

  validates :story_id, uniqueness: { scope: %i[language paragraph_strategy] }
  validates :paragraph_strategy, presence: true,
                                 format: { with: /\w+-v([\d.]+)/,
                                           message: 'We only support simple-v0.1 and smart-v0.1 at the moment' }
  # , message: 'No spaces, just dash underscores and lower cases'
  #
  # DELETE IN CASCADE all of its

  after_create :fix_missing_attributes
  #  after_save :after_each_save_fix_cheap_missing_attributes

  def self.default_genai_model
    # 'bison@001'
    'text-bison@001'
  end

  # after save, many times
  def after_each_save_fix_cheap_missing_attributes
    puts 'after_each_save_fix_cheap_missing_attributes'
    if story.kid_id.nil?
      self.kid_id = story.kid.id
      save
    end
    # same as above but done with robocop
    return unless language.nil? or language == ''

    self.language = story.kid.favorite_language
    save

    true
    # self.language ||= story.kid.favorite_language
  end

  def set_translated_title
    # sleep(10)
    self.translated_title = google_translate(story.title, language)
    save
    # translated_title = "TODO (simulate a google translate from story title =#{story.title})"
  end

  # after create, only once
  def fix_missing_attributes
    puts 'fix_missing_attributes'
    self.kid_id ||= story.kid.id
    self.language ||= story.kid.favorite_language || DEFAULT_LANGUAGE # Italian :)
    self.paragraph_strategy ||= DEFAULT_PARAGRAPH_STRATEGY # 'smart-v0.1' # TODO export as
    append_notes('TranslatedStory.fix_missing_attributes called')
    # delay(queue: 'translated_story::set_translated_title').set_translated_title if translated_title.to_s == ''
    set_translated_title if translated_title.to_s == ''
    save
  end

  # disabled rubocop as per https://stackoverflow.com/questions/62562455/visual-studio-code-disabling-error-warning-checks-in-for-specific-file-type
  def to_s
    # Damn rubocop! "#{self.emoji} #{name}"
    if translated_title.to_s.size > 1
      "#{flag} #{translated_title}"
    else
      "#{flag} #{TranslatedStory.emoji} #{name}"
    end
  end

  def flag
    waving_flag(self.language)
  end

  def self.emoji
    # 🈳👅 # cant choose between the 2..'
    '🈳' # cant choose between the 2..'
  end

  def paragraphs_with_no_images
    story_paragraphs.map { |x| [x.id, x.attached?] }.select { |a| a[1] == false }.map { |a| a[0] }
  end

  def fix
    # TODO
    fix_missing_attributes
    # Check children translated_stories for missing images
    # =>  [[204, false]]
    paragraphs_with_no_images.each do |id|
      puts "Missing image for #{id}"
      StoryParagraph.find(id).generate_ai_images!
    end
  end

  def simple_paragraphs(_algorithm_version)
    story.simple_paragraphs
  end

  def smart_paragraphs(_algorithm_version)
    story.smart_paragraphs
  end

  def polymorphic_paragraphs
    paragraph_strategy_base, paragraph_strategy_version = begin
      paragraph_strategy.split('-v')
    rescue StandardError
      [nil, nil]
    end
    case paragraph_strategy_base # paragraph_strategy: simple-v0.1
    when 'simple'
      simple_paragraphs(paragraph_strategy_version)
    when 'smart'
      smart_paragraphs(paragraph_strategy_version)
    else
      puts "Unknown typology '#{paragraph_strategy_base}'.."
      []
    end
  end

  def generate_polymorphic_paragraphs(_opts = {})
    # lang = _opts.fetch(:lang, DEFAULT_LANGUAGE)
    # lang = self.language
    key = _opts.fetch(:key, GOOGLE_TRANSLATE_KEY2)

    cached_pars = polymorphic_paragraphs

    # find or create by story and lang :)

    puts "Story.generate_paragraphs(). Size: #{cached_pars.size}"
    # return if StoryParagraph.find(story_id: id).count > 0
    cached_pars.each_with_index do |p, _ix|
      story_ix = _ix + 1 # start from 1.. Im pretty sure Im gonna regret this :)
      puts "⅞T0d0 #{StoryParagraph.emoji} [#{story_ix}] #{p}"
      # StoryParagraph(story_index: integer, original_text: text, genai_input_for_image: text,
      sp = StoryParagraph.create(
        language: self.language,
        story_index: story_ix,
        story_id: story.id,
        internal_notes: "Created via TranslatedStory.generate_polymorphic_paragraphs on #{Time.now}\n",
        original_text: p,
        translated_story_id: id
      )
      puts(sp)
      puts "SP ERROR: #{sp.errors.full_messages}" unless sp.save
    end
  end
end
