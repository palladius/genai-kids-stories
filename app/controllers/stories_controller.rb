class StoriesController < ApplicationController
  before_action :set_story, only: %i[show edit update destroy genai_magic]

  # Google proxy gives me an error =>
  # https://stackoverflow.com/questions/65688157/why-is-my-http-origin-header-not-matching-request-base-url-and-how-to-fix
  skip_before_action :verify_authenticity_token

  # GET /stories or /stories.json
  def index
    @stories = Story.all.order('created_at DESC')
  end

  # GET /stories/1 or /stories/1.json
  def show; end

  def show_rebuilt
    @story = Story.find(params[:id])
    @paragraphs = @story.story_paragraphs.sort
    @translate_to = params[:translate_to] # or , nil)
    # if @translate_to do magic in controller?
  end

  # GET /stories/new
  def new
    @story = Story.new
  end

  def genai_magic
    # set_story :)
    puts 'Doing some magic here :)'
  end

  # GET /stories/1/edit
  def edit; end

  # POST /stories or /stories.json
  def create
    @story = Story.new(story_params)

    respond_to do |format|
      if @story.save
        format.html { redirect_to story_url(@story), notice: 'Story was successfully created.' }
        format.json { render :show, status: :created, location: @story }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stories/1 or /stories/1.json
  def update
    respond_to do |format|
      if @story.update(story_params)
        format.html { redirect_to story_url(@story), notice: 'Story was successfully updated.' }
        format.json { render :show, status: :ok, location: @story }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stories/1 or /stories/1.json
  def destroy
    @story.destroy

    respond_to do |format|
      format.html { redirect_to stories_url, notice: 'Story was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_story
    @story = Story.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def story_params
    params.require(:story).permit(:title, :genai_input, :genai_output, :genai_summary, :internal_notes, :user_id,
                                  :kid_id, :cover_image, :additional_images) # : []
  end
end
