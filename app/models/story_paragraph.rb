# A story is composed of N paragraphs
# #
class StoryParagraph < ApplicationRecord
  belongs_to :story

  validates :story_index, numericality: { in: 1..100 }
  validates :rating, numericality: { in: 1..5 }

  def self.emoji
    '📜'
  end
end
