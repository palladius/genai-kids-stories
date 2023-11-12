class PagesController < ApplicationController
  def index
    @num_stories = Story.all.count rescue "?!?"
    @sample_ts = TranslatedStory.last
#    @ts_id = .id
    #@ts_lang = TranslatedStory.last.language
    #@ts_name = TranslatedStory.last.name
  end

  def about
  end

  def help
    response = slow_function()
#    render partial: 'index', locals: { data: response }
    # render partial: 'index', locals: { data: response }
    render 'help', locals: { data: response }
  end

  private

  def slow_function()
    sleep(1)
    return "[FAKE] slow_function(): API returned: 42"
  end
end
