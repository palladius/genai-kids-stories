# frozen_string_literal: true

#  ##Kid
# id: integer
# name: string
# surname: string
# nick: string
# visual_description: string
# is_male: boolean
# date_of_birth: date
# internal_info: text
# user_id: integer,
# favorite_language: string)
#
# , :active
# Added :interests (text)
# end
# Storage:
# * `avatar` (with thumnb)

FIXTURE_DIR ||= "#{Rails.root}/db/fixtures/images/".freeze

class Kid < ApplicationRecord
  include AiImageable
  DefaultInterests = 'rainbows, unicorns, the number FortiTwo'

  # For Story and Kid, maybe I should raise a Concern?? :)
  scope :active, -> { where('active = TRUE') }
  scope :inactive, -> { where('active = FALSE') }

  after_create :genai_magic # DEBUG

  # unique keys
  validates :nick, presence: true, uniqueness: { scope: :user_id }
  validates :favorite_language, presence: true, format: { with: AVAIL_LANGUAGE_REGEX,
                                                          message: 'We only support (2) Italian, Spanish, portuguese, german, english, Russian and Japanese now. Ok now also 🇫🇷 :)' }

  before_save :set_interests_if_unset
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

  def flag
    waving_flag(favorite_language.to_s)
  end

  # alias
  def language
    favorite_language
  end

  # 3 years -> 🕯️🕯️🕯️
  def candles
    ('🕯️' * age)
  end

  def to_s(verbose = false)
    #    "Kiddo.#{id}: #{nick}, #{age}y: '#{visual_description}'"
    return "#{Kid.emoji} #{nick}, (#{candles})" if verbose

    "#{flag} #{nick} (#{age}y)"
  end

  # Alessandro is a 5-year old kid, ...
  def about
    #   "#{name} is a #{age}-year-old #{visual_description}"
    "#{name} is a #{visual_description}"
  end
  def set_interests_if_unset
    if self.interests.to_s.length < 3
      self.interests = DefaultInterests
    end
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
    my_UPLOAD_MAX_SIZE = 22.megabyte
    errors.add(:avatar, "is too big (UPLOAD_MAX_SIZE=#{my_UPLOAD_MAX_SIZE/1000000}MB, current_size=#{avatar.blob.byte_size/1000000})") unless avatar.blob.byte_size <= my_UPLOAD_MAX_SIZE

    acceptable_types = ['image/jpeg', 'image/png']
    return if acceptable_types.include?(avatar.content_type)

    errors.add(:avatar, 'must be a JPEG or PNG')
  end

  def genai_compute_images2!(_gcp_opts = {})
    extend Genai::AiplatformTextCurl
    desc = "The cartoon version of #{visual_description}, in the style of Pixar"
    ret1 = genai_compute_single_image_by_decription(avatar, desc, _gcp_opts)
  end

  def fix
    genai_compute_images2! unless avatar.attached?
  end

  def fix!
    genai_compute_images2!
  end

  def genai_magic(_opts = {})
    # Thsi is such a minor thing that we can afford to delay and play with the DELAYED jobs :)
    # TODO only enqueue if NOT avatar attached?
    delay(queue: 'kid::image_creation').fix
  end
end
