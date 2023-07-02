class TranslatedStoriesController < ApplicationController
  before_action :set_translated_story, only: %i[show edit update destroy]

  # GET /translated_stories or /translated_stories.json
  def index
    @translated_stories = TranslatedStory.all
  end

  # GET /translated_stories/1 or /translated_stories/1.json
  def show; end

  # GET /translated_stories/new
  def new
    @translated_story = TranslatedStory.new
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
    @translated_story = TranslatedStory.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def translated_story_params
    params.require(:translated_story).permit(:name, :user_id, :story_id, :language, :kid_id, :paragraph_strategy,
                                             :internal_notes, :genai_model)
  end
end
