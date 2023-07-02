#
# This is something I should have created A LONG TIME AGO :)
class TranslatedStory < ApplicationRecord
  belongs_to :user
  belongs_to :story

  def self.default_genai_model
    # 'bison@001'
    'text-bison@001'
  end
end
