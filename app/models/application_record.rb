class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.yellow(s)
    "\033[1;33m#{s}\033[0m"
  end
end
