# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

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
      ret[:attachment_name] = send(field_name).attachment.blob.filename.to_s
      ret[:content_type] = send(field_name).attachment.blob.content_type # .keys
      ret[:service_name] = send(field_name).attachment.blob.service_name # .keys
      # ret[:blob] = send(field_name).attachment.blob.inspect # .keys
      ret[:created_at] = send(field_name).attachment.blob.created_at
      ret[:byte_size] = send(field_name).attachment.blob.byte_size
      ret[:metadata] = send(field_name).attachment.blob.metadata

    end
    # ": attacched? = #{ret} ; attachment_name=#{attachment_name}"
    ret
  end
end
