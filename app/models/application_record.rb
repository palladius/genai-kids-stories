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
    ret = begin
      send(field_name).attached?
    rescue StandardError
      :ERROR
    end
    attachment_name = send(field_name).attachment.blob.filename if ret
    "AR::attached_stuff_info(#{field_name}): attacched? = #{ret} ; attachment_name=#{attachment_name}"
  end
end
