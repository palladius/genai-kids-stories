#
# This is something I should have created A LONG TIME AGO :)
class TranslatedStory < ApplicationRecord
  belongs_to :user # Oops its done in the DB, optional: true
  belongs_to :story

  validates :story_id, uniqueness: { scope: %i[language paragraph_strategy] }
  # , message: 'No spaces, just dash underscores and lower cases'

  after_create :fix_missing_attributes

  def self.default_genai_model
    # 'bison@001'
    'text-bison@001'
  end

  def fix_missing_attributes
    puts 'fix_missing_attributes'
    self.kid_id ||= story.kid.id
    self.language ||= story.kid.favorite_language
    self.internal_notes += "TranslatedStory.fix_missing_attributes called on #{Time.now} ||\n"
    save
  end
end
