#
# This is something I should have created A LONG TIME AGO :)
class TranslatedStory < ApplicationRecord
  belongs_to :user # Oops its done in the DB, optional: true
  belongs_to :story
  belongs_to :kid

  validates :story_id, uniqueness: { scope: %i[language paragraph_strategy] }
  # , message: 'No spaces, just dash underscores and lower cases'

  after_create :fix_missing_attributes
  after_save :after_each_save_fix_cheap_missing_attributes

  def self.default_genai_model
    # 'bison@001'
    'text-bison@001'
  end

  # after save, many times
  def aftereach_save_fix_cheap_missing_attributes
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

  # after create, only once
  def fix_missing_attributes
    puts 'fix_missing_attributes'
    self.kid_id ||= story.kid.id
    self.language ||= story.kid.favorite_language
    self.internal_notes += "TranslatedStory.fix_missing_attributes called on #{Time.now} ||\n"
    save
  end

  def to_s
    "#{self.emoji} #{name}"
  end

  def self.emoji
    #🈳👅 # cant choose between the 2..'
    '🈳' # cant choose between the 2..'
  end
end
