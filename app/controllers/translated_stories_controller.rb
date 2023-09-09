class TranslatedStoriesController < ApplicationController
  before_action :set_translated_story, only: %i[show edit update destroy]

  # GET /translated_stories or /translated_stories.json
  #     limit_per_page = 6
  # @stories = Story.all.active.order('score DESC, created_at DESC').paginate(page: params[:page], per_page: limit_per_page)
  # @total_pages = @stories.count / limit_per_page

  def index
    limit_per_page = 10
    @pluralized_entity = 'translated_stories'
    #@translated_stories = TranslatedStory.all
    @translated_stories = TranslatedStory.all.order('score DESC, created_at DESC').paginate(page: params[:page], per_page: limit_per_page)
    @total_pages = @translated_stories.count / limit_per_page
  end

  # GET /translated_stories/1 or /translated_stories/1.json
  def show
    #  hidden @translated_story
    @story_paragraphs = StoryParagraph.where(translated_story_id: @translated_story.id).order('story_index ASC')
    # TODO: .sort by
    @execute_now = params[:execute_now] == 'true'
  end

  # GET /translated_stories/new
  def new
    @translated_story = TranslatedStory.new(
      language: params['language'],
      story_id: params['story_id'],
      name: params['name'],
      internal_notes: params['internal_notes']
    )
  end

  # GET /translated_stories/1/fix
  def fix # _translated_story
    @translated_story = begin
      TranslatedStory.find(params[:id])
    rescue StandardError
      nil
    end
    @ret = begin
      if params.fetch(:delay, '') == 'true'
        @translated_story.delay(queue: 'translated_stories_controller::fix').fix
      else
        @translated_story.fix
      end
    rescue StandardError
      nil
    end
  end

  # GET /translated_stories/1/edit
  def edit; end

  # POST /translated_stories or /translated_stories.json
  def create
    @translated_story = TranslatedStory.new(translated_story_params)

    respond_to do |format|
      if @translated_story.save
        format.html do
          redirect_to translated_story_url(@translated_story), notice: 'Translated story was successfully created.'
        end
        format.json { render :show, status: :created, location: @translated_story }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @translated_story.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /translated_stories/1 or /translated_stories/1.json
  def update
    respond_to do |format|
      if @translated_story.update(translated_story_params)
        format.html do
          redirect_to translated_story_url(@translated_story), notice: 'Translated story was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @translated_story }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @translated_story.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /translated_stories/1 or /translated_stories/1.json
  def destroy
    @translated_story.destroy

    respond_to do |format|
      format.html { redirect_to translated_stories_url, notice: 'Translated story was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_translated_story
    @translated_story = TranslatedStory.find(params[:id])  rescue redirect_to( translated_stories_url, notice: "Translated Story #{params[:id]} error: #{ $! }")
  end

  # Only allow a list of trusted parameters through.
  def translated_story_params
    params.require(:translated_story).permit(:name, :user_id, :story_id, :language, :kid_id, :paragraph_strategy, :translated_title,
                                             :translated_story, :internal_notes, :genai_model, :score)
  end
end
