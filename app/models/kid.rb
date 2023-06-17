FIXTURE_DIR = "#{Rails.root}/db/fixtures/images/"

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

  #validates_presence_of :is_male

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








  # Class stuff
  def self.create_kid_on_steorids(attributes)
    opts_debug = attributes.fetch :opts_debug, true

    puts "Kid.create_kid_on_steorids(): Provided attributes: #{attributes}"
    #puts "FA: #{yellow attributes[:fixture_avatar] }"
    fixture_avatar_pic = attributes.fetch(:fixture_avatar, 'anonymous.png')

    cleaned_up_attributes = attributes.delete_if { |key, value| key.to_s.match(/fixture_avatar/) }
    #puts "cleaned_up_attributes: #{cleaned_up_attributes}"
    #puts Kid.column_names.join(', ')
    puts cleaned_up_attributes

    puts "DEB fixture_avatar_pic=#{yellow fixture_avatar_pic}"
    #cleaned_up_attributes['visual_description'] ||= ''
    #cleaned_up_attributes['visual_description'] += "DEBUG -- fixture_avatar_pic=#{fixture_avatar_pic}"

    ################################################
    # Creation of object...
    kid = Kid.create(cleaned_up_attributes )
    puts "👶 Kid just created: #{kid}. Errors: #{kid.errors.full_messages}" if opts_debug
    # ... now it exists and I can methods like age() and so on.
    ################################################

    # if not attributes.key? :visual_description
    #   attributes[:visual_description] ||= "#{@age}-year-old #{@is_male ? 'boy' : 'girl'}"
    # end

    kid.avatar.attach(io: File.open("#{FIXTURE_DIR}/#{fixture_avatar_pic}"), filename: fixture_avatar_pic )

    # Saving for second time with additional stuff..
    ret = kid.save
    puts "ret=#{ret}"
    puts "DEB kid: #{kid}"
    puts ''
  end
end
