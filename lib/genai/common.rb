
# extend Genai::Common
# or simply =>  Genai::Common.offline?
# Genai::Common.network_offline?

module Genai
  # Only allow authenticated admins access to precious resources.
  module Common

    # def network_offline?()
    #   ENV.fetch('NETWORK_OFFLINE', false)
    # end

    def self.network_offline?()
      ENV.fetch('NETWORK_OFFLINE', false)
    end

  end
end
