## Ricc, Also create one for attachments (but its parametric in attachment name)
## and one for AI_Textable :)
## https://blog.appsignal.com/2020/09/16/rails-concers-to-concern-or-not-to-concern.html
module AiImageable
  extend ActiveSupport::Concern

  included do
    # t0d0
    #
    # This for SP
    #
    ## OBSOLETE
    # def generate_one_genai_image_from_image_description!
    #   #   return genai_compute_single_image!(p_image1) if is_a?(StoryParagraph)
    #   #   return genai_compute_single_image!(:avatar) if is_a?(Kid)
    #   #   return if is_a?(StoryParagraph)
    #   return unless is_a?(StoryParagraph)

    #   description = genai_input_for_image.gsub(/\n/, ' ') # usually long story with quotes and so on.
    #   puts 'SP mayeb refactor when u find the caller...'
    #   genai_compute_single_image_by_decription(p_image1, description, gcp_opts = {})

    #   # def generate_one_genai_image_from_image_description!
    #   #   return genai_compute_single_image!(:p_image1) if is_a?(StoryParagraph)
    #   #   # return genai_compute_single_image!(:avatar) if is_a?(Kid)
    #   #   return if is_a?(StoryParagraph)

    #   #   raise "generate_one_genai_image_from_image_description(): wrong class: #{self.class} "
    # end

    def genai_compute_single_image_by_decription(model_attached_single_image, description, gcp_opts = {})
      extend Genai::AiplatformTextCurl
      extend Genai::AiplatformImageCurl

      opts_force_attach = gcp_opts.fetch :force_attach, true # only debug! TODO remove!
      opts_model_version = gcp_opts.fetch :model_version, '002'

      if model_attached_single_image.attached? and !opts_force_attach
        puts('genai_compute_single_image_by_decription!(): pointless since I already have an attachment!')
        return false
      end

      # puts("genai_compute_single_image!(opts=#{gcp_opts.to_s.first(25)}..): output-size=#{genai_output_size}")

      # _, tmp_image = ai_curl_images_by_content(description, gcp_opts)
      # this is called in different places i want to make sure i call it right :)
      ai_ret = ai_curl_images_by_content_v2(opts_model_version, description, gcp_opts) # .merge(mock: true))
      _, images, ret_hash = ai_ret
      puts "AAAB.genai_compute_single_image_by_decription ret_hash: #{ret_hash}"

      return false if images.nil?
      return false if images == []

      tmp_image = images[0]
      puts ''
      puts "tmp_image: '#{tmp_image}'"
      puts("ai_ret.inspect: '''#{ai_ret.inspect}'''")
      puts ''

      # puts("genai_compute_single_image! returned a: #{tmp_image} (class=#{tmp_image.class})")
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

          # TODO: self.update_columns(:model_attached_single_image => attach.?!? )
          model_attached_single_image.attach(
            io: File.open(tmp_image),
            filename: tmp_image,
            # https://stackoverflow.com/questions/48999264/metadata-about-blobs-stored-with-activestorage-with-rails-5
            metadata: {
              aiHash: 'TODO ricc surface it from response if you can',
              callingFunction: 'genai_compute_single_image_by_decription',
              original_description: description,
              model_version: opts_model_version
            }
          )
          # TODO: attach 4 images instead! Like the 4 MJ ones :)
          # self.append_notes "Correctly attached image #{tmp_image} with this description: '#{description}'"
          save!
          # self.update_column ...
          return true
        else
          puts "💔 Sorry, file not found: #{tmp_image}"
          return false
        end
      end
      false
    end

    # def genai_compute_single_image!(model_attached_single_image, gcp_opts = {})
    #   raise 'deprecated'
    #   extend Genai::AiplatformTextCurl
    #   extend Genai::AiplatformImageCurl

    #   if model_attached_single_image.attached?
    #     puts('genai_compute_single_image!(): pointless since I already have an attachment!')
    #     return false
    #   end

    #   case self.class.name.to_sym
    #   when :StoryParagraph
    #     puts 'StoryParagraph, yay!'
    #     genai_input = genai_input_for_image # if SP
    #     genai_output_size = 42 # you need to define it in SP
    #     title = story.title
    #     genai_output = original_text
    #     # My god this is SOOO WRONG!

    #   when :Kid
    #     puts 'TODO'
    #     # Todo consider putting the code in the model itself, seems less stupid :)
    #     # when "foo", "bar"
    #     #   "It's either foo or bar"
    #     # when String
    #     #   "You passed a string"
    #     # else
    #     #   puts "Unsupported class: #{self.class} (is=-a StoryParagraph ? #{is_a? StoryParagraph})"
    #     #   return
    #   when :Story
    #     puts 'TODO Story'
    #   end

    #   #   genai_input = genai_input_for_image # if SP
    #   #   genai_output_size = 42 # you need to define it in SP
    #   #   title = story.title
    #   #   genai_output = original_text
    #   # I get a lot of recursive on this - so better get out immediately

    #   # puts("genai_compute_single_image!(opts=#{gcp_opts.to_s.first(25)}..): output-size=#{genai_output_size}")
    #   # self.append_notes "genai_compute_single_image called."
    #   # description = "Once upon a time, there was a young spy named Agent X. Agent X was the best spy in the world, and she was always on the lookout for new mysteries to solve. One day, Agent X was sent on a mission to investigate a mysterious cave at the bottom of a mountain."
    #   # tmp_imagez = ai_curl_images_by_content(self.kid.about)
    #   #
    #   description = if genai_input =~ /Kids love hearing about the stories you invent/
    #                   # Story for kids..
    #                   "Imagine #{kid.about}. In the background, #{title}".gsub("\n", ' ')
    #                 else
    #                   # TODO: add a field like "story for kids", "joke, or whatever..."
    #                   "Imagine: #{title}.\nAdditional context: #{genai_output}" # .gsub("\n",' ')
    #                 end

    #   # _, tmp_image = ai_curl_images_by_content(description, gcp_opts)
    #   # this is called in different places i want to make sure i call it right :)
    #   ai_ret = ai_curl_images_by_content_v2('002', description, gcp_opts) # gcp_opts.merge(mock: true))
    #   _, images, ret_hash = ai_ret
    #   puts "AAAA.ai_curl_images_by_content_v2 ret_hash: #{ret_hash}"
    #   tmp_image = begin
    #     images[0]
    #   rescue StandardError
    #     nil
    #   end
    #   puts ''
    #   puts "tmp_image: '#{tmp_image}'"
    #   puts("ai_ret.inspect: '''#{ai_ret.inspect}'''")
    #   puts ''

    #   # raise 'read logs and removeme'

    #   # puts "genai_compute_single_image.response: #{response}"
    #   # puts("genai_compute_single_image! returned a: #{tmp_image} (class=#{tmp_image.class})")
    #   unless tmp_image.nil?
    #     if tmp_image.is_a? Hash
    #       puts 'Super interesting plot twist, we have a hash here. I cant remember why I wanted to throw a hash maybe to implement a function to return a structured image without the filename? Lets print it first'
    #       puts(tmp_image)
    #       return false
    #     end
    #     if File.exist?(tmp_image)
    #       # from SO:
    #       # image: {
    #       #  io: StringIO.new(Base64.decode64(params[:base_64_image].split(',')[1])),
    #       #  content_type: 'image/jpeg',
    #       #  filename: 'image.jpeg'
    #       # }
    #       puts "WOWOWOW about to save this image: #{tmp_image}"
    #       puts `file "#{tmp_image}"`

    #       # TODO: self.update_columns(:model_attached_single_image => attach.?!? )
    #       model_attached_single_image.attach(
    #         io: File.open(tmp_image),
    #         filename: tmp_image
    #       )
    #       # TODO: attach 4 images instead! Like the 4 MJ ones :)
    #       # self.append_notes "Correctly attached image #{tmp_image} with this description: '#{description}'"
    #       save!
    #       # self.update_column ...
    #       return true
    #     end
    #   end
    #   false
    # end
  end

  class_methods do
    # todo
  end
end
