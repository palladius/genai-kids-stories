# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  # DEFLT for everyone: https://github.com/mislav/will_paginate
  WillPaginate.per_page = 10

  def attach_file_to_attachable_field(_attachable_field, _filename)
    _attachable_field.attach(io: File.open(File.expand_path(_filename)), filename: _filename)
  end

  # https://stackoverflow.com/questions/49515529/rails-5-2-active-storage-purging-deleting-attachments
  # for commodity I put it on parent :) It would be nicer on sub classes but this shows me a SINGLE method, and
  # its easier to see if its missing somewhere :)
  def delete_all_images
    # Story version :)
    return self.cover_image.purge if is_a?(Story)
    if is_a?(StoryParagraph)
      # TODO
      puts "DEBUG ApplicationRecord::delete_all_images: its a SP!"
      self.p_image1.purge
      self.p_image2.purge
      self.p_image3.purge
      self.p_image4.purge
      return self.p_images.purge
    end
    if is_a?(TranslatedStory)
      self.story_paragraphs.each do |sp|
        sp.delete_all_images
      end
      return
    end
  end


  # initially used for Story but useful for others as well..
  def append_notes(str)
    self.internal_notes ||= '🌍'
    self.internal_notes += "::append:: AppVer=#{APP_VERSION} #{Time.now} #{str}\n"
    # self.update_column(:internal_notes => self.internal_notes) rescue nil
  end

  # woohoo https://stackoverflow.com/questions/49525843/rails-get-a-random-record-from-db
  def self.find_sample
    find(ids.sample)
  end

  def validity_emoji
    valid? ? '✅' : '❌'
  end

  def self.autofix # fix_all
    all.each do |model|
      model.fix
    end
  end

  # Alias which is more memorable :)
  def generate
    fix
  end
  def generate!
    fix!
  end

  def super_attached_stuff_info(field_name)
    ret = {
      header: "AR::attached_stuff_info(#{field_name}) v1.1",
      is_attached: send(field_name).attached?
    }
    if send(field_name).attached?
      ret[:attachment_name] = begin
        send(field_name).attachment.blob.filename.to_s
      rescue StandardError
        "Err: #{$!}"
      end
      ret[:content_type] = begin
        send(field_name).attachment.blob.content_type
      rescue StandardError
        "Err: #{$!}"
      end
      ret[:service_name] = begin
        send(field_name).attachment.blob.service_name
      rescue StandardError
        "Err: #{$!}"
      end
      # ret[:blob] = send(field_name).attachment.blob.inspect # .keys
      ret[:created_at] = begin
        send(field_name).attachment.blob.created_at
      rescue StandardError
        "Err: #{$!}"
      end
      ret[:byte_size] = begin
        send(field_name).attachment.blob.byte_size
      rescue StandardError
        "Err: #{$!}"
      end
      ret[:blob_metadata] = begin
        send(field_name).attachment.blob.metadata
      rescue StandardError
        "Err: #{$!}"
      end

      ret[:blob_key] = send(field_name).attachment.blob.key rescue nil
      ret[:blob_url] = send(field_name).attachment.blob.url rescue nil
      #ret[:blob_filename] = send(field_name).attachment.blob.filename rescue nil
      ret[:blob_signed_id] = send(field_name).attachment.blob.signed_id rescue nil
      ret[:blob_custom_metadata] = send(field_name).attachment.blob.custom_metadata rescue nil

      ret[:blob_is_image] = send(field_name).attachment.blob.image? rescue nil
      ret[:blob_is_audio] = send(field_name).attachment.blob.audio? rescue nil
      ret[:blob_is_video] = send(field_name).attachment.blob.video? rescue nil
      ret[:url_for_direct_upload] = send(field_name).attachment.blob.url_for_direct_upload rescue nil
      ret[:headers_for_direct_upload] = send(field_name).attachment.blob.headers_for_direct_upload rescue nil

      #ret[:download] = send(field_name).attachment.blob.download rescue nil

    end
    # ": attacched? = #{ret} ; attachment_name=#{attachment_name}"
    ret
  end

  def self.emoji
    '?'
  end

end
