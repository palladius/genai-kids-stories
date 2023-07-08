# TODO: change project id
class GCauth
  include Singleton

  EXPIRY_TIME_IN_SECONDS = 900 # 15 minutes
  # max_duration = 15/minutes

  def populate_and_return_token
    # TODO: change project id
    @token_value = `gcloud --project '#{@project_id}' auth print-access-token`.chomp
    @updated_at = Time.now
    @token_value
  end

  def initialize(_project_id = nil)
    # puts 'DEBUG initializer'
    # @project = 'ricc-genai'
    @token_value = nil
    @updated_at = nil
    @project_id = begin
      PROJECT_ID
    rescue StandardError
      DEFAULT_PROJECT_ID # 'ricc-genai'
    end #  from ENV
  end

  # TODO: ricc:
  # do gcloud get auth token. When u do, record the time.
  # Memoize it until the time ends and then get it aga
  def get_auth_token(_opts = {})
    opts_debug = _opts.fetch :debug, true
    return populate_and_return_token if @token_value.nil? or @updated_at.nil?

    if token_expired?
      puts 'Token has expired! Reloading..' if opts_debug
      return populate_and_return_token
    end

    puts "Token obsolescence: #{Time.now - @updated_at}sec" if opts_debug
    # check if it needs refresh
    @token_value
  end

  def token_expired?
    Time.now - @updated_at > EXPIRY_TIME_IN_SECONDS
  end

  alias token get_auth_token
end
