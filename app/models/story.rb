


class Story < ApplicationRecord
  belongs_to :kid
#  has_one_attached :cover_image

  has_one_attached :cover_image do |attachable|
    attachable.variant :thumb, resize_to_limit: [200, 200]
  end

  #validates :title, uniqueness: { scope: :user_id }

  #https://stackoverflow.com/questions/33890458/difference-between-after-create-after-save-and-after-commit-in-rails-callbacks
  #after_create :delayed_job_genai_magic
  # doesnt work since its unauthorized maybe different process  -> different ENVs?
  # #<Net::HTTPUnauthorized 401 Unauthorized readbody=true>
  #after_save :delayed_job_genai_magic # The right way


  # This works
  after_save :genai_magic # DEBUG


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

  def paragraphs
    genai_output.split("\n").reject{ |c| c.length < 4  } # empty?
  end



  #### MAGIC AI

  def delayed_job_genai_magic
    Rails.logger.info("delayed_job_genai_magic(): 1. Enqueuing GenAI Magic for Story.#{self.id}")
    self.delay.genai_magic
  end
  def should_compute_genai_output?
    genai_input.size > 10 and genai_output.size < 10
  end
  def should_compute_genai_summary?
    self.genai_output.size > 10 and    self.genai_summary.size < 10
  end
  def should_autogenerate_genai_input?
    self.genai_input.size < 11
  end
  # to be DELAYed
  # https://github.com/collectiveidea/delayed_job/tree/v4.1.11
  # @story.delay.genai_compute!(@device)
  def genai_magic()
    # This function has the arrogance of doing EVERYTHING which needs to be done. It will defer to sub-parts and
    # might take time, hence done with 'delayed_job'
    Rails.logger.info("genai_magic(): 2. actually executing GenAI Magic for Story.#{self.id}")

    if should_autogenerate_genai_input? # total autopilot :)
      puts 'I have no input -> computing the Guillaume story template (implemented)'
      self.genai_autogenerate_input!()
      sleep(1)
    end
    if should_compute_genai_output?
      puts 'I have input but no output -> computing it with Generate API (implemented)'
      self.genai_compute_output!()
    end
    if  should_compute_genai_summary?
      puts 'I have output but no summary -> computing it with Summary API (TODO)'
      self.genai_compute_summary!()
    end
  end

  def genai_compute_output!()
    extend Genai::AiplatformTextCurl
    x = ai_curl_by_content(self.genai_input)
    if x.nil?
      logger.error('Sorry I couldnt generate anything.')
      return nil
    end
    ret,msg = x
    # TODO verify that [0] is 200 ok :) #<Net::HTTPOK 200 OK readbody=true>
    self.genai_output = msg
    self.internal_notes = "genai_compute_output() Invoked on #{Time.now}"
    self.save!
  end

  def genai_compute_summary!()
    extend Genai::AiplatformTextCurl
    ret,msg = ai_curl_by_content("Please write a short summary of maximum 10 words of the following text: #{self.genai_output}")
    # TODO verify that [0] is 200 ok :) #<Net::HTTPOK 200 OK readbody=true>
    self.genai_summary = msg
    self.internal_notes = "genai_compute_summary() Invoked on #{Time.now}"
    self.title = genai_summary if title.size < 5
    self.save!
  end

  def genai_autogenerate_input!()
    extend Genai::AiplatformTextCurl
#    kid_description = self.kid.visual_description # TODO get also personality and hobbies.
    self.genai_input = guillaume_kids_story_in_five_acts()
    self.save!
  end

end
