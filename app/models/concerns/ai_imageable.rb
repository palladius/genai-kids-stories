## Ricc, Also create one for attachments (but its parametric in attachment name)
## and one for AI_Textable :)
## https://blog.appsignal.com/2020/09/16/rails-concers-to-concern-or-not-to-concern.html
module AiImageable
  extend ActiveSupport::Concern

  included do
    # t0d0
    #
    # This for SP
    def generate_one_genai_image_from_image_description!
      return genai_compute_single_image!(p_image1) if is_a?(StoryParagraph)
      return genai_compute_single_image!(:avatar) if is_a?(Kid)
      return if is_a?(StoryParagraph)

      raise "generate_one_genai_image_from_image_description(): wrong class: #{self.class} "
    end

    def genai_compute_single_image!(model_attached_single_image, gcp_opts = {})
      extend Genai::AiplatformTextCurl

      if model_attached_single_image.attached?
        puts('genai_compute_single_image!(): pointless since I already have an attachment!')
        return false
      end

      case self.class
      when StoryParagraph
        genai_input = genai_input_for_image # if SP
        genai_output_size = 42 # you need to define it in SP
        title = story.title
        genai_output = original_text
      when Kid
        puts 'TODO'
        # Todo consider putting the code in the model itself, seems less stupid :)
        # when "foo", "bar"
        #   "It's either foo or bar"
        # when String
        #   "You passed a string"
      else
        puts "Unsupported class: #{self.class} (is=-a StoryParagraph ? #{is_a? StoryParagraph})"
        return
      end

      # if is_a? StoryParagraph
      #   genai_input = genai_input_for_image # if SP
      #   genai_output_size = 42 # you need to define it in SP
      #   title = story.title
      #   genai_output = original_text
      # end
      # I get a lot of recursive on this - so better get out immediately

      puts("genai_compute_single_image!(opts=#{gcp_opts.to_s.first(25)}..): output-size=#{genai_output_size}")
      # self.append_notes "genai_compute_single_image called."
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
      # puts "genai_compute_single_image.response: #{response}"
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
  end

  class_methods do
    # todo
  end
end
