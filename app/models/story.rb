# frozen_string_literal: true

class Story < ApplicationRecord
  belongs_to :kid
  #  has_one_attached :cover_image
  has_many :story_paragraphs

  has_one_attached :cover_image, service: :google do |attachable|
    attachable.variant :thumb, resize_to_limit: [200, 200]
  end
  # GCS test :)
  has_many_attached :additional_images, service: :google

  # validates :title, uniqueness: { scope: :user_id }

  # https://stackoverflow.com/questions/33890458/difference-between-after-create-after-save-and-after-commit-in-rails-callbacks
  # after_create :delayed_job_genai_mag
  # doesnt work since its unauthorized maybe different process  -> different ENVs?
  # #<Net::HTTPUnauthorized 401 Unauthorized readbody=true>

  # after_save  OK with delayed, but not with
  # after_save :delayed_job_genai_magic # The right way

  # This works
  # # Note: after_save creates a loop!!!
  after_create :genai_magic # DEBUG

  def self.emoji
    '📚'
  end

  # seby_story1.attach_cover('seby-firefighter.png')
  def attach_cover(filename)
    # self.cover_image =   cover_image: attachment # File.open("#{STORIES_FIXTURE_IMAGES_DIR}/seby-firefighter.png"), #, filename: 'seby-firefighter.png' )
    cover_image.attach(
      io: File.open("#{STORIES_FIXTURE_IMAGES_DIR}/#{filename}"),
      filename:
    )
  end

  def attached_stuff_info
    {
      cover_image: super_attached_stuff_info(:cover_image),
      additional_images: super_attached_stuff_info(:additional_images)

    }
  end

  def self.test_image_attachment(_path = nil)
    # path ||= Rails.root.join('app/assets/images/kids/doll.jpg')
    # filename = 'test_image_attachment_doll.png'
    {
      io: File.open(Rails.root.join('app/assets/images/kids/doll.jpg')),
      filename: 'doll.jpg',
      # content_type: 'image/jpeg',
      identify: true

    }
  end

  # Just a test!
  def attach_test_image(opts = {})
    opts_save_afterwards = opts.fetch :save_afterwards, true
    opts_purge_before = opts.fetch :purge_before, true

    # https://stackoverflow.com/questions/45870021/how-to-update-attachment-in-activestorage-rails-5-2
    begin
      cover_image.purge
    rescue StandardError
      :maybe_nothing_topurge
    end # if opts_purge_before
    # cover_image.attach(io: File.open(Rails.root.join('app/assets/images/kids/doll.jpg')),
    #                    filename: 'doll.jpg')
    cover_image.attach(Story.test_image_attachment)
    return unless opts_save_afterwards

    save_ok = save!
    puts("save_ok=#{save_ok} - ERRORS: #{errors.full_messages}")
    puts save_ok
  end

  def paragraphs
    # needs to remove '**Act 1**'
    genai_output.split("\n").reject { |c| c.length < 12 }.map { |x| x.chomp }
  rescue StandardError
    []
    # empty?
  end

  def append_notes(str)
    self.internal_notes ||= '🌍'
    self.internal_notes += "::append:: #{Time.now} #{str}\n"
    # self.update_column(:internal_notes => self.internal_notes) rescue nil
  end

  def to_s
    "#{Story.emoji}.#{id} '#{title}'"
  end

  #### MAGIC AI
  #
  def genai_input_size
    genai_input.size
  rescue StandardError
    0
  end

  def genai_output_size
    genai_output.size
  rescue StandardError
    0
  end

  def genai_summary_size
    genai_summary.size
  rescue StandardError
    0
  end

  def title_size
    title.size
  rescue StandardError
    0
  end

  def delayed_job_genai_magic
    Rails.logger.info("delayed_job_genai_magic(): 1. Enqueuing GenAI Magic for Story.#{id}")
    delay.genai_magic(delay: true)
  end

  def should_compute_genai_output?
    genai_input_size > 10 and genai_output_size < 10
  end

  def should_compute_genai_summary?
    genai_output_size > 10 and genai_summary_size < 10
  end

  def should_autogenerate_genai_input?
    genai_input_size < 11
  end

  def should_compute_genai_images?
    # title_size > 10 and not ...
    !cover_image.attached?
  end

  # to be DELAYed
  # https://github.com/collectiveidea/delayed_job/tree/v4.1.11
  # @story.delay.genai_compute!(@device)
  def genai_magic(opts = {})
    delay = opts.fetch :delay, false
    # This function has the arrogance of doing EVERYTHING which needs to be done. It will defer to sub-parts and
    # might take time, hence done with 'delayed_job'
    Rails.logger.info("genai_magic(delay=#{delay}): 2. actually executing GenAI Magic for Story.#{id}")

    gcp_opts = {
      project_id: PROJECT_ID,
      gcloud_access_token: GCLOUD_ACCESS_TOKEN
    }

    if should_autogenerate_genai_input? # total autopilot :)
      puts '🤖10🤖 I have no input -> computing the Guillaume story template (implemented)'
      ret10 = genai_autogenerate_input! # doesnt require GCP :)
    end
    if should_compute_genai_output?
      puts '🤖20🤖 I have input but no output -> computing it with Generate API (implemented)'
      ret20 = genai_compute_output!(gcp_opts)
    end
    if should_compute_genai_summary?
      puts '🤖30🤖 I have output but no summary -> computing it with Summary API (implemented)'
      ret30 = genai_compute_summary!(gcp_opts)
    end
    if should_compute_genai_images?
      puts "🤖40🤖 WOWOWOW [#{Story.emoji}.#{id}] computing images with Palm API (implemented)"
      ret40 = genai_compute_images!(gcp_opts)
    end
    append_notes("genai_magic(delay=#{delay}) END. Results: #{ret10}/#{ret20}/#{ret30}/#{ret40}/")
    # self.save
  end

  def genai_compute_output!(gcp_opts = {})
    extend Genai::AiplatformTextCurl
    x = ai_curl_by_content(genai_input, gcp_opts)
    if x.nil?
      logger.error('Sorry I couldnt generate anything.')
      return nil
    end
    _, msg = x
    # TODO: verify that [0] is 200 ok :) #<Net::HTTPOK 200 OK readbody=true>
    self.genai_output = msg
    append_notes 'genai_compute_output() Invoked'
    save!
  end

  def genai_compute_summary!(gcp_opts = {})
    extend Genai::AiplatformTextCurl

    ret, msg = ai_curl_by_content(
      "Please write a short summary of maximum 10 words of the following text: #{genai_output}", gcp_opts
    )

    # puts("ret ..", ret)
    # TODO verify that [0] is 200 ok :) #<Net::HTTPOK 200 OK readbody=true>
    self.genai_summary = msg
    append_notes 'genai_compute_summary() Invoked'
    self.title = genai_summary if title_size < 5
    save!
    ret
  end

  def genai_autogenerate_input!
    extend Genai::AiplatformTextCurl

    puts("genai_autogenerate_input!(): #{kid.about}")
    append_notes "genai_autogenerate_input called on #{kid}"
    self.genai_input = guillaume_kids_story_in_five_acts(kid_description: kid.about)
    save!
  end

  def genai_compute_images!(gcp_opts = {})
    extend Genai::AiplatformTextCurl
    # I get a lot of recursive on this - so better get out immediately
    if cover_image.attached?
      puts('genai_compute_images!(): pointless since I already have an attachment!')
      return false
    end

    puts("genai_compute_images!(opts=#{gcp_opts.to_s.first(25)}..): output-size=#{genai_output_size}")
    # self.append_notes "genai_compute_images called."
    # description = "Once upon a time, there was a young spy named Agent X. Agent X was the best spy in the world, and she was always on the lookout for new mysteries to solve. One day, Agent X was sent on a mission to investigate a mysterious cave at the bottom of a mountain."
    # tmp_imagez = ai_curl_images_by_content(self.kid.about)
    #
    description = if genai_input =~ /Kids love hearing about the stories you invent/
                    # Story for kids..
                    "Imagine #{kid.about}. In the background, #{title}".gsub("\n", ' ')
                  else
                    # TODO: add a field like "story for kids", "joke, or whatever..."
                    "Imagine: #{title}.\nAdditional context: #{genai_output}" # .gsub("\n",' ')
                  end

    _, tmp_image = ai_curl_images_by_content(description, gcp_opts)
    # puts "genai_compute_images.response: #{response}"
    # puts("genai_compute_images! returned a: #{tmp_image} (class=#{tmp_image.class})")
    unless tmp_image.nil?
      if tmp_image.is_a? Hash
        puts 'Super interesting plot twist, we have a hash here. I cant remember why I wanted to throw a hash maybe to implement a function to return a structured image without the filename? Lets print it first'
        puts(tmp_image)
        return false
      end
      if File.exist?(tmp_image)
        # from SO:
        # image: {
        #  io: StringIO.new(Base64.decode64(params[:base_64_image].split(',')[1])),
        #  content_type: 'image/jpeg',
        #  filename: 'image.jpeg'
        # }
        puts "WOWOWOW about to save this image: #{tmp_image}"
        puts `file "#{tmp_image}"`

        # TODO: self.update_columns(:cover_image => attach.?!? )
        cover_image.attach(
          io: File.open(tmp_image),
          filename: tmp_image
        )
        # TODO: attach 4 images instead! Like the 4 MJ ones :)
        # self.append_notes "Correctly attached image #{tmp_image} with this description: '#{description}'"
        save!
        # self.update_column ...
        return true
      end
    end
    false
  end

  def generate_paragraphs(_opts = {})
    lang = _opts.fetch(:lang, DEFAULT_LANGUAGE)
    puts 'generate_paragraphs START..'
    puts "Size: #{paragraphs.size}"
    # return if StoryParagraph.find(story_id: id).count > 0
    paragraphs.each_with_index do |p, _ix|
      story_ix = _ix + 1 # start from 1.. Im pretty sure Im gonna regret this :)
      puts "TODO #{StoryParagraph.emoji} [#{story_ix}] #{p}"
      # StoryParagraph(story_index: integer, original_text: text, genai_input_for_image: text,
      sp = StoryParagraph.create(
        language: lang,
        story_index: story_ix,
        story_id: id,
        # rating: nil,
        internal_notes: "Created via Story.generate_paragraphs on #{Time.now}\n",
        # translated_text: nil,
        original_text: p
        # genai_input_for_image: nil
      )
      puts "SP ERROR: #{sp.errors.full_messages}" unless sp.save
      # s.save!
    end
    # puts 'generate_paragraphs END..'
  end
end
