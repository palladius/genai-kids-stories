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
# # ADDED translated_title
##
# t.index ["kid_id"], name: "index_translated_stories_on_kid_id"
# t.index ["story_id"], name: "index_translated_stories_on_story_id"
# t.index ["user_id"], name: "index_translated_stories_on_user_id"
# end

#
#
#
# This is something I should have created A LONG TIME AGO :)
class TranslatedStory < ApplicationRecord
  belongs_to :user # Oops its done in the DB, optional: true
  belongs_to :story
  belongs_to :kid, optional: true

  # validates :language, presence: true # A TS needs a Story and a Language, STRONGLY.
  validates :language, presence: true,
                       format: { with: AVAIL_LANGUAGE_REGEX,
                                 message: 'We only support ITalian, Spanish, portuguese, german, english, Russian and Japanese now. Ok now also 🇫🇷 :)' }

  validates :story_id, uniqueness: { scope: %i[language paragraph_strategy] }
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
    sleep(10)
    translated_title = "TODO (simulate a google translate from story title =#{story.title})"
  end

  # after create, only once
  def fix_missing_attributes
    puts 'fix_missing_attributes'
    self.kid_id ||= story.kid.id
    self.language ||= story.kid.favorite_language || DEFAULT_LANGUAGE # Italian :)
    self.internal_notes += "TranslatedStory.fix_missing_attributes called on #{Time.now} ||\n"
    delay(queue: 'translated_story::set_translated_title').set_translated_title if translated_title.to_s == ''
    save
  end

  # disabled rubocop as per https://stackoverflow.com/questions/62562455/visual-studio-code-disabling-error-warning-checks-in-for-specific-file-type
  def to_s
    # Damn rubocop! "#{self.emoji} #{name}"
    "#{TranslatedStory.emoji} #{name} [TODO translated title '#{translated_title}']"
  end

  def flag
    waving_flag(self.language)
  end

  def self.emoji
    # 🈳👅 # cant choose between the 2..'
    '🈳' # cant choose between the 2..'
  end
end
