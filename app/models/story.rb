# frozen_string_literal: true

#   create_table "stories", force: :cascade do |t|
# t.string "title"
# t.text "genai_input"
# t.text "genai_output"
# t.text "genai_summary"
# t.text "internal_notes"
# t.integer "user_id"
# t.bigint "kid_id", null: false
# t.index ["kid_id"], name: "index_stories_on_kid_id"
# #
#       , :active
# end

class Story < ApplicationRecord
  include AiImageable

  # For Story and Kid, maybe I should raise a Concern?? :)
  scope :active, -> { where('active = TRUE') }
  scope :inactive, -> { where('active = FALSE') }

  belongs_to :kid
  #  has_one_attached :cover_image
  has_many :story_paragraphs
  has_many :translated_stories

  has_one_attached :cover_image, service: :google do |attachable|
    attachable.variant :thumb, resize_to_limit: [200, 200]
  end
  # GCS test :)
  has_many_attached :additional_images, service: :google
  has_many_attached :paragraphs_images

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
  before_destroy :cleanup_story_dependencies

  def self.emoji
    '📚'
  end

  def cleaned_up_title
    title.gsub('**', '')
  end

  # seby_story1.attach_cover('seby-firefighter.png')
  def attach_cover(filename, _opts = {})
    # self.cover_image =   cover_image: attachment # File.open("#{STORIES_FIXTURE_IMAGES_DIR}/seby-firefighter.png"), #, filename: 'seby-firefighter.png' )
    cover_image.attach(
      io: File.open("#{STORIES_FIXTURE_IMAGES_DIR}/#{filename}"),
      metadata: { function: 'attach_cover' },
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

  def cleanup_story_dependencies
    story_paragraphs.each do |p|
      p.delete
    end
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

  def simple_paragraphs
    # needs to remove '**Act 1**'
    genai_output.split("\n").reject { |c| c.length < 12 }.map { |x| x.chomp }
  rescue StandardError
    []
    # empty?
  end

  def paragraphs
    # puts "TODO consider also using https://apidock.com/rails/v5.2.3/ActionView/Helpers/TextHelper/split_paragraphs"
    smart_paragraphs(min_chunk_size = 150)
  end

  def smart_paragraphs(min_chunk_size = 200)
    # TODO(ricc): split intelligently and a bit bigger chuinks
    split_paragraphs_brd(genai_output, min_chunk_size)
    # split_into_chunks_cg(genai_output, min_chunk_size)
  end

  # wrong
  def split_paragraphs_brd(str, min_chunk_size)
    paragraphs = []
    current_paragraph = ''
    str.each_line do |line|
      if current_paragraph.length >= min_chunk_size
        paragraphs << current_paragraph
        current_paragraph = ''
      end
      current_paragraph += line
    end
    paragraphs << current_paragraph
    # paragraphs
    paragraphs.reject { |c| c.length < 5 }.map { |x| x.chomp }
  end

  def split_into_chunks_cg(str, min_chunk_size)
    paragraphs = str.split("\n")
    chunks = []

    current_chunk = ''
    paragraphs.each do |paragraph|
      if current_chunk.length + paragraph.length <= min_chunk_size
        current_chunk += paragraph + "\n"
      else
        chunks << current_chunk.rstrip unless current_chunk.empty?
        current_chunk = paragraph + "\n"
      end
    end
    # ???
    chunks << current_chunk.rstrip unless current_chunk.empty?
    # chunks
    chunks.reject { |c| c.length < 5 }.map { |x| x.chomp }
  end

  # # Example usage:
  # big_string = "Paragraph 1\nParagraph 2\nParagraph 3\nParagraph 4\nParagraph 5\nParagraph 6"
  # chunks = split_into_chunks(big_string)
  # puts chunks.inspect
  # In this example, the split_into_chunks method takes a string as input and returns an array of chunks. It splits the string into paragraphs using the "\n" delimiter and then loops through the paragraphs. It keeps adding paragraphs to the current_chunk variable as long as the length of the chunk (including the current paragraph) does not exceed 200 characters. Once the length limit is reached, the current chunk is added to the chunks array, and a new chunk is started with the current paragraph.

  # The resulting chunks are stored in the chunks array, and in this example, we print the array using inspect. You can modify the code to suit your specific needs, such as storing the chunks in a variable or performing further processing on them.

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
    delay(queue: 'story::genai_magic').genai_magic(delay: true)
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
    title_size > 10 and !cover_image.attached?
  end

  # to be DELAYed
  # https://github.com/collectiveidea/delayed_job/tree/v4.1.11
  # @story.delay.genai_compute!(@device)
  def genai_magic(opts = {})
    delay = opts.fetch :delay, false
    force = opts.fetch :force, false
    # This function has the arrogance of doing EVERYTHING which needs to be done. It will defer to sub-parts and
    # might take time, hence done with 'delayed_job'
    Rails.logger.info("genai_magic(delay=#{delay}): 2. actually executing GenAI Magic for Story.#{id}")

    gcp_opts = {
      project_id: AI_PROJECT_ID,
      gcloud_access_token: GCauth.instance.token # GCLOUD_ACCESS_TOKEN
    }

    if force or should_autogenerate_genai_input? # total autopilot :)
      puts '🤖10🤖 I have no input -> computing the Guillaume story template (implemented)'
      ret10 = genai_autogenerate_input! # doesnt require GCP :)
    end
    if force or should_compute_genai_output?
      puts '🤖20🤖 I have input but no output -> computing it with Generate API (implemented)'
      ret20 = genai_compute_output!(gcp_opts)
    end
    if force or should_compute_genai_summary?
      puts '🤖30🤖 I have output but no summary -> computing it with Summary API (implemented)'
      ret30 = genai_compute_summary!(gcp_opts)
    end
    if force or should_compute_genai_images?
      puts "🤖40🤖 Exciting! [#{Story.emoji}.#{id}] Trying to compute images with Palm API (implemented)"
      ret40 = genai_compute_images!(gcp_opts)
    end
    append_notes("genai_magic(force=#{force},delay=#{delay}) END. Results: #{ret10}/#{ret20}/#{ret30}/#{ret40}")
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

  def genai_compute_images!(_gcp_opts = {})
    extend Genai::AiplatformTextCurl
    # I get a lot of recursive on this - so better get out immediately
    # return unless cover_image.attached?

    puts('genai_compute_images!(): pointless since I already have an attachment!')

    description = if genai_input =~ /Kids love hearing about the stories you invent/
                    # Story for kids..
                    #                    "Imagine #{kid.visual_description}. In the background, #{cleaned_up_title}".gsub("\n", ' ')
                    #                    "Imagine #{kid.visual_description}. In the background, #{genai_summary}".gsub("\n", ' ')
                    "#{kid.visual_description}. #{genai_summary}".gsub("\n", ' ')
                  else
                    # TODO: add a field like "story for kids", "joke, or whatever..."
                    #                    "Imagine: #{title}.\nAdditional context: #{genai_output}" # .gsub("\n",' ')
                    "Imagine: #{kid.visual_description}.Additional context: #{genai_output}" # .gsub("\n",' ')
                  end

    description = description.gsub('*', '').gsub("'", '')
    ret1 = genai_compute_single_image_by_decription(cover_image, description, _gcp_opts)
    # puts("ret1: #{yellow(ret1)}")
    # if Google doesnt pass this we can try this instead
    if ret1 === false
      puts 'Some errors maybe due to kids. Let me try again without the Kid part.'
      #      genai_compute_single_image_by_decription(cover_image, title, _gcp_opts)
      ret1 = genai_compute_single_image_by_decription(cover_image, genai_summary, _gcp_opts)
    end
    if ret1 === false
      puts 'Some errors maybe due to kids. Let me try again without the Kid part. Try 2'
      ret1 = genai_compute_single_image_by_decription(cover_image, genai_summary, _gcp_opts)
    end
    if ret1 === false
      puts 'Some errors maybe due to kids. Let me try again without the Kid part. Try 3'
      ret1 = genai_compute_single_image_by_decription(cover_image, genai_summary, _gcp_opts)
    end
    # puts "some errors" unless ret
    ret1
  end

  # This is the OBSOLETE way of doing this
  def generate_paragraphs(_opts = {})
    lang = _opts.fetch(:lang, DEFAULT_LANGUAGE)
    key = _opts.fetch(:key, GOOGLE_TRANSLATE_KEY2)

    # find or create by story and lang :)
    parent_ts = TranslatedStory.where(story_id: id, language: lang).first

    unless parent_ts.instance_of?(::TranslatedStory)
      # if u dont find it, create it
      parent_ts = TranslatedStory.create(
        name: "[auto generated from] #{self}",
        user: begin
          current_user
        rescue StandardError
          User.first
        end,
        language: lang,
        story_id: id,
        kid_id: kid.id,
        internal_notes: 'Generated randomly before going to work as part of Story create paragraphs since otherwise createpagraphs is broken since now its a needed field :)'
      )
    end
    puts "Errors for Parent TS: #{parent_ts.errors}"
    # return 'tutto ok'
    # puts 'generate_paragraphs START..'
    puts "Story.generate_paragraphs(). Size: #{paragraphs.size}"
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
        original_text: p,
        translated_story_id: parent_ts.id
        # genai_input_for_image: nil
      )
      puts(sp)
      puts "SP ERROR: #{sp.errors.full_messages}" unless sp.save
      # sp.after_creation_delayed_magic
      # s.save!
    end
    # puts 'generate_paragraphs END..'
  end

  def fix_paragraphs_now(_now = true)
    StoryParagraph.where(story_id: id).each_with_index do |p, _ix|
      if _now
        p.after_creation_magic
      else
        p.delay(queue: 'story::fix_paragraphs').after_creation_magic
      end
    end
  end

  def fix
    genai_magic(delay: false, force: false)
    fix_paragraphs_now(false)
    # copy_images_from_primogenitos_images
  end

  # force
  def copy_images_from_primogenitos_images!
    return false if translated_stories.size < 1 # no TS available

    ts1 = translated_stories.first
    ts1.story_paragraphs.each_with_index do |sp, ix|
      paragraphs_images.attach(
        sp.p_image1.blob,
        metadata: {
          # aiHash: 'TODO ricc surface it from response if you can',
          callingFunction: 'copy_images_from_primogenitos_images',
          # original_description: description,
          # model_version: opts_model_version
          ix:,
          sp_id: sp.id
        }
      )
    end
  end

  def copy_images_from_primogenitos_images
    unless paragraphs_images.empty?
      puts "Sorry I already see images size=#{paragraphs_images.size}. Skip unless you force me to"
      return true
    end

    copy_images_from_primogenitos_images!
  end

  def fix!
    genai_magic(delay: false, force: true)
    fix_paragraphs_now(true)
    # genai_compute_images2!
    # genai_magic!
  end

  def self.fix_all
    Story.all.each do |story|
      story.fix
    end
  end

  def self.default_paragraph_strategy
    DEFAULT_PARAGRAPH_STRATEGY
    #    'simple-v0.1' # tokenization by slash N
    # minsize-v0.1
  end

  def generate_migration_translated_story
    # there can be only one PRE migration. Good news!
    translated_story_id = begin
      translated_story_ids.first
    rescue StandardError
      nil
    end
    unless translated_story_id.nil?
      puts 'No need to generate_migration_translated_story: translated_story_id finally exists! Yuppie!! Returning proper object'
      return TranslatedStory.find(translated_story_id)
    end

    # infer_language = 'it' # TODO: check children
    languages = StoryParagraph.where(story: self).map { |x| x.language }.uniq
    raise "A mix of different languages here. I refuse to continue: #{languages}" unless languages.size == 1

    # infer_language = languages[0]

    ret = TranslatedStory.create(
      paragraph_strategy: Story.default_paragraph_strategy,
      internal_notes: "Created via Story.generate_migration_translated_story appver=#{APP_VERSION}",
      language: languages[0],
      story_id: id,
      kid_id: kid.id,
      user_id: kid.user_id,
      name: 'one-off migration clean me afterwards'
      # translated_story_id: 42
    )
    puts("Model.generate_migration_translated_story TS.valid=#{ret.valid?}")
    puts(ret.errors.full_messages) unless ret # oK!
    ret
  end

  # Since i have multiple translated stories, I wanna make sure only the 'primogenito' has images.
  # The other attach images from primogenito. This is because Im too lazy to do the
  # correct thing and create yet another thing.
  def first_translated_story
    translated_stories.sort { |x, y| x.created_at <=> y.created_at }.first
  rescue StandardError
    nil
  end

  def genai_output_excerpt(max_size = 250)
    genai_output.first(max_size).gsub('*', '').gsub(/Act [12345]/, '') + '..'
  end
end
