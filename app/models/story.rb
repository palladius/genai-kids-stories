STORIES_FIXTURE_IMAGES_DIR = "#{Rails.root}/db/fixtures/stories/"

class Story < ApplicationRecord
  belongs_to :kid
  has_one_attached :cover_image

  validates :title, uniqueness: { scope: :user_id }


  def self.emoji
    '📚'
  end

  #seby_story1.attach_cover('seby-firefighter.png')
  def attach_cover(filename)
    #self.cover_image =   cover_image: attachment # File.open("#{STORIES_FIXTURE_IMAGES_DIR}/seby-firefighter.png"), #, filename: 'seby-firefighter.png' )
    self.cover_image.attach(
      io: File.open("#{STORIES_FIXTURE_IMAGES_DIR}/#{filename}"),
      filename: filename )

  end

end
