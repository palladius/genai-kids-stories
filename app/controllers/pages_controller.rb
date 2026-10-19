class PagesController < ApplicationController
  # https://stackoverflow.com/questions/35181340/rails-cant-verify-csrf-token-authenticity-when-making-a-post-request
  protect_from_forgery with: :null_session
  # https://stackoverflow.com/questions/11311090/how-to-remove-header-and-footer-from-some-of-the-pages-in-ruby-on-rails
  layout 'application', except: 'slow_function' # %i[slow_function ai_test]

  def index
    @num_stories = begin
      Story.active.count
    rescue StandardError
      '?!?'
    end
    @featured_stories = begin
      Story.active.order('score DESC, created_at DESC').limit(6)
    rescue StandardError
      []
    end
    @sample_ts = TranslatedStory.where('cached_completion >= 99').order('created_at DESC').first || TranslatedStory.last
  end

  def about; end

  def ai_test
    respond_to do |format|
      format.html { render layout: false } # redirect_to stories_url, notice: 'Story was successfully destroyed.' }
      # format.text { render layout: false } # redirect_to stories_url, notice: 'Story was successfully destroyed.' }
      format.json {} #  head :no_content }
    end
  end

  def help
    # response = slow_function
    #    render partial: 'index', locals: { data: response }
    # render partial: 'index', locals: { data: response }
    # render 'help', locals: { data: response }
  end

  private

  def slow_function
    # sleep(1)
    # '[FAKE] slow_function(): API returned: 42'
    # render 'help', locals: { data: response }
    respond_to do |format|
      format.html { render layout: false } # redirect_to stories_url, notice: 'Story was successfully destroyed.' }
      format.text { render layout: false } # redirect_to stories_url, notice: 'Story was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
end
