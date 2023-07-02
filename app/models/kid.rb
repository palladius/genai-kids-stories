# frozen_string_literal: true

# create_table "kids", force: :cascade do |t|
#   t.string "name"
#   t.string "surname"
#   t.string "nick"
#   t.string "visual_description"
#   t.boolean "is_male"
#   t.date "date_of_birth"
#   t.text "internal_info"
#   t.integer "user_id"
# end
# Storage:
# * `avatar` (with thumnb)

FIXTURE_DIR ||= "#{Rails.root}/db/fixtures/images/".freeze

class Kid < ApplicationRecord
  include AiImageable

  # unique keys
  validates :nick, presence: true, uniqueness: { scope: :user_id }
  # has_one_attached :avatar, service: :local

  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [200, 200]
  end

  # must have attributes
  validates :name, presence: true
  validates :date_of_birth, presence: true
  validates :date_of_birth, comparison: { less_than: DateTime.tomorrow }
  # validates :visual_description, presence: true
  validate :acceptable_image

  # (attributes = {}, options = {})
  def self.initialize
    # super
    @visual_description ||= "#{@age}-year-old #{@is_male ? 'boy' : 'girl'}"
  end

  def gender
    is_male ? 'male' : 'female'
  end

  def age
    (DateTime.tomorrow - date_of_birth).to_i / 365
  end

  def to_s
    #    "Kiddo.#{id}: #{nick}, #{age}y: '#{visual_description}'"
    "#{Kid.emoji} #{nick}, #{age}y"
  end

  # Alessandro is a 5-year old kid, ...
  def about
    #   "#{name} is a #{age}-year-old #{visual_description}"
    "#{name} is a #{visual_description}"
  end

  def self.emoji
    '👶'
  end

  # Class stuff
  def self.create_kid_on_steorids(attributes)
    opts_debug = attributes.fetch :opts_debug, false

    puts "Kid.create_kid_on_steorids(): Provided attributes: #{attributes}" if opts_debug
    # puts "FA: #{yellow attributes[:fixture_avatar] }"
    fixture_avatar_pic = attributes.fetch(:fixture_avatar, 'anonymous.png')

    cleaned_up_attributes = attributes.delete_if { |key, _value| key.to_s.match(/fixture_avatar/) }
    # puts "cleaned_up_attributes: #{cleaned_up_attributes}"
    # puts Kid.column_names.join(', ')
    # puts cleaned_up_attributes if opts_debug

    # puts "DEB fixture_avatar_pic=#{yellow fixture_avatar_pic}" if opts_debug
    # cleaned_up_attributes['visual_description'] ||= ''
    # cleaned_up_attributes['visual_description'] += "DEBUG -- fixture_avatar_pic=#{fixture_avatar_pic}"

    ################################################
    # Creation of object...
    kid = Kid.create(cleaned_up_attributes)
    puts "👶 Kid just created: #{kid}. Errors: #{kid.errors.full_messages}" # if opts_debug
    # ... now it exists and I can methods like age() and so on.
    ################################################

    # if not attributes.key? :visual_description
    #   attributes[:visual_description] ||= "#{@age}-year-old #{@is_male ? 'boy' : 'girl'}"
    # end

    kid.avatar.attach(io: File.open("#{FIXTURE_DIR}/#{fixture_avatar_pic}"), filename: fixture_avatar_pic)

    # Saving for second time with additional stuff..
    kid.save
    # puts "ret=#{ret}"
    # puts "DEB kid: #{kid}"
    # puts ''
    kid
  end

  def attached_stuff_info
    super_attached_stuff_info(:avatar)
  end

  def akkusativ
    return 'them' if is_male.nil?

    is_male ? 'him' : 'her'
  end

  # so cool! Copied from here https://pragmaticstudio.com/tutorials/using-active-storage-in-rails
  def acceptable_image
    return unless avatar.attached?

    errors.add(:avatar, 'is too big (10 megs?!?)') unless avatar.blob.byte_size <= 10.megabyte

    acceptable_types = ['image/jpeg', 'image/png']
    return if acceptable_types.include?(avatar.content_type)

    errors.add(:avatar, 'must be a JPEG or PNG')
  end

  def genai_compute_images2!(_gcp_opts = {})
    extend Genai::AiplatformTextCurl
    desc = "The cartoon version of #{visual_description}, in the style of Pixar"
    ret1 = genai_compute_single_image_by_decription(avatar, desc, _gcp_opts)
  end
end
