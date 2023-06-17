class Story < ApplicationRecord
  belongs_to :kid
  has_one_attached :cover_image
end
