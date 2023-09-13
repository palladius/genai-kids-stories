class StoriesController < ApplicationController
  before_action :set_story, only: %i[show edit update destroy genai_magic]

  # Google proxy gives me an error =>
  # https://stackoverflow.com/questions/65688157/why-is-my-http-origin-header-not-matching-request-base-url-and-how-to-fix
  skip_before_action :verify_authenticity_token

  # GET /stories or /stories.json
  def index
    limit_per_page = 6
    @pluralized_entity = 'stories'
    @stories = Story.all.active.order('score DESC, created_at DESC').paginate(page: params[:page], per_page: limit_per_page)
    @total_pages = @stories.count / limit_per_page
  end

  # GET /stories/1 or /stories/1.json
  def show; end

  def show_rebuilt
    @story = Story.find(params[:id])
    @story_paragraphs = @story.story_paragraphs.sort
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
    @story = Story.find(params[:id]) rescue redirect_to( stories_url, notice: "Story #{params[:id]} error: #{ $! }")

    # https://stackoverflow.com/questions/2139996/how-to-redirect-to-previous-page-in-ruby-on-rails
    session[:return_to] ||= request.referer

    @already_translated = []
    TranslatedStory.where(story_id: @story.id).each do |ts|
      @already_translated << ts.language
    end
  end

  # Only allow a list of trusted parameters through.
  def story_params
    params.require(:story).permit(:title, :genai_input, :genai_output, :genai_summary, :internal_notes, :user_id,
      # note on []: https://github.com/rails/rails/issues/35072
                                  :kid_id, :cover_image, :additional_images, :active, :score) # : []
  end
end
