# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  # DEFLT for everyone: https://github.com/mislav/will_paginate
  WillPaginate.per_page = 10

  def self.yellow(s)
    "\033[1;33m#{s}\033[0m"
  end

  # woohoo https://stackoverflow.com/questions/49525843/rails-get-a-random-record-from-db
  def self.find_sample
    find(ids.sample)
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
      ret[:metadata] = begin
        send(field_name).attachment.blob.metadata
      rescue StandardError
        "Err: #{$!}"
      end

    end
    # ": attacched? = #{ret} ; attachment_name=#{attachment_name}"
    ret
  end
end
