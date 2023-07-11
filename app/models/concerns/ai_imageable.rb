## Ricc, Also create one for attachments (but its parametric in attachment name)
## and one for AI_Textable :)
## https://blog.appsignal.com/2020/09/16/rails-concers-to-concern-or-not-to-concern.html
module AiImageable
  extend ActiveSupport::Concern

  included do
    def genai_compute_single_image_by_decription(model_attached_single_image, description, gcp_opts = {})
      extend Genai::AiplatformTextCurl
      extend Genai::AiplatformImageCurl
      my_function_version = '0.4'

      opts_force_attach = gcp_opts.fetch :force_attach, true # only debug! TODO remove!
      opts_model_version = gcp_opts.fetch :model_version, '002'

      if model_attached_single_image.attached? and !opts_force_attach
        puts('genai_compute_single_image_by_decription!(): pointless since I already have an attachment!')
        return false
      end

      description = cleaned_up_content(description)

      # _, tmp_image = ai_curl_images_by_content(description, gcp_opts)
      # this is called in different places i want to make sure i call it right :)
      ai_ret = ai_curl_images_by_content_v2(opts_model_version, description, gcp_opts) # .merge(mock: true))
      _, images, ret_hash = ai_ret


      return false if images.nil?
      return false if images == []

      tmp_image = images[0]
      puts ''
      puts "tmp_image: '#{tmp_image}'"
      puts "🧐 images.size: '#{images.size}'"

      unless tmp_image.nil?
        if tmp_image.is_a? Hash
          puts 'Super interesting plot twist, we have a hash here. I cant remember why I wanted to throw a hash maybe to implement a function to return a structured image without the filename? Lets print it first'
          puts(tmp_image)
          return false
        end
        if File.exist?(tmp_image)
          puts "🍉WOWOWOW1🍉 about to save this image: #{tmp_image}. " + `file "#{tmp_image}"`
          aiHash =  'unknown1'
          if m = tmp_image.match(/\.dmi=(\d+)\.png$/)
            puts("🌱Seed1🌱 ☘️found☘️! #{m[1]} in #{tmp_image}..")
            aiHash = m[1]
          end

          # TODO: self.update_columns(:model_attached_single_image => attach.?!? )
          model_attached_single_image.attach(
            io: File.open(tmp_image),
            filename: tmp_image,
            # https://stackoverflow.com/questions/48999264/metadata-about-blobs-stored-with-activestorage-with-rails-5
            metadata: {
              aiHash: aiHash,
              callingFunction: "genai_compute_single_image_by_decription-v#{my_function_version}",
              original_description: description,
              model_version: opts_model_version,
              filename_maybe_redundant: tmp_image, # maybe redundant, if so lets remove it
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

    # Called only by StoryParagraph now :) try: sp.fix
    def genai_compute_multiple_images_by_decription(_model_attached_multiple_images, description, gcp_opts = {})
      extend Genai::AiplatformTextCurl
      extend Genai::AiplatformImageCurl

      opts_force_attach = gcp_opts.fetch :force_attach, true # only debug! TODO remove!
      opts_model_version = gcp_opts.fetch :model_version, '002' # TODO: move to 002

      if _model_attached_multiple_images.attached? and !opts_force_attach
        puts('genai_compute_single_image_by_decription!(): pointless since I already have some attachments!')
        return false
      end

      description=cleaned_up_content(description)

      # this is called in different places i want to make sure i call it right :)
      ai_ret = ai_curl_images_by_content_v2(opts_model_version, description, gcp_opts) # .merge(mock: true))

      _, images, ret_hash = ai_ret

      puts(" 👁️ 🧐 DEB 🧐: #{ai_ret}")
      return false if images.nil?
      return false if images == []

      images.each_with_index do |tmp_image, _ix|
        # tmp_image = images[0]
        puts yellow("genai_compute_multiple_images_by_decription(ix=#{_ix})")
        puts "tmp_image[#{_ix}]: '#{tmp_image}'"
        puts "🧐 images.size: '#{images.size}'"

        next if tmp_image.nil?

        if tmp_image.is_a? Hash
          puts 'Super interesting plot twist, we have a hash here. I cant remember why I wanted to throw a hash maybe to implement a function to return a structured image without the filename? Lets print it first'
          puts(tmp_image)
          return false
        end
        if File.exist?(tmp_image)
          puts "🍉WOWOWOW2🍉 about to save this image: #{tmp_image}. " + `file "#{tmp_image}"`

          aiHash = 'unknown2'

          if m = tmp_image.match(/\.dmi=(\d+)\.png$/)
            puts("🌱Seed2🌱 ☘️found☘️! #{m[1]} in #{tmp_image}..")
            aiHash = m[1]
          end

          # TODO: self.update_columns(:model_attached_single_image => attach.?!? )
          _model_attached_multiple_images.attach(
            io: File.open(tmp_image),
            filename: tmp_image,
            metadata: {
              aiSeed: aiHash, #'TODO2 ricc surface it from deployedModelId in response',
              callingFunction: 'genai_compute_multiple_images_by_decription',
              original_description: description,
              model_version: opts_model_version,
              original_file: tmp_image,
            }
          )
          if _ix == 0 # and _model_attached_multiple_images == p_images
            p_image1.attach(
              io: File.open(tmp_image),
              filename: tmp_image,
              metadata: {
                aiSeed: 'TODO ricc surface it from deployedModelId in response',
                callingFunction: 'genai_compute_multiple_images_by_decription',
                original_description: description,
                model_version: opts_model_version
              }
            )
          end
          # TODO: attach 4 images instead! Like the 4 MJ ones :)
          # self.append_notes "Correctly attached image #{tmp_image} with this description: '#{description}'"
          save!
          # self.update_column ...
          # return true
        else
          puts "💔 Sorry, file not found: #{tmp_image}"
          # return false
        end
      end
      true
    end
  end

  class_methods do
    # todo
  end
end
