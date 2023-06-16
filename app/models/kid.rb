class Kid < ApplicationRecord
  # unique keys
  validates :nick, presence: true, uniqueness: { scope: :user_id }
  #has_one_attached :avatar, service: :local

  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [200, 200]
  end

  # must have attributes
  validates :name, presence: true
  validates :date_of_birth, presence: true
  validates :date_of_birth, comparison: { less_than: DateTime.tomorrow }
  #validates :visual_description, presence: true

  validates_presence_of :is_male

  def self.initialize # (attributes = {}, options = {})
    #super
    @visual_description ||= "#{@age}-year-old #{@is_male ? 'boy' : 'girl'}"
  end

  def gender
    is_male ? 'male' : 'female'
  end

  def age
    (DateTime.tomorrow - date_of_birth).to_i / 365
  end

  def to_s
    "Kiddo.#{id}: #{nick}, #{age}y: '#{visual_description}'"
  end
end
