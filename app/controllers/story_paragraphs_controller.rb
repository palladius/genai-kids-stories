class StoryParagraphsController < ApplicationController
  before_action :set_story_paragraph, only: %i[show edit update destroy regenerate_images gen_audio]

  # GET /story_paragraphs or /story_paragraphs.json
  def index
    @story_paragraphs = StoryParagraph.all
    # efficient from https://stackoverflow.com/questions/68646374/how-to-get-the-all-unique-value-using-foreign-key-in-rails
    @stories_with_paragraphs = StoryParagraph.pluck('story_id').uniq
  end

  # GET /story_paragraphs/1 or /story_paragraphs/1.json
  def show; end

  # GET /story_paragraphs/new
  def new
    @story_paragraph = StoryParagraph.new
  end

  # GET /story_paragraphs/1/edit
  def edit; end

  # POST /story_paragraphs or /story_paragraphs.json
  def create
    @story_paragraph = StoryParagraph.new(story_paragraph_params)

    respond_to do |format|
      if @story_paragraph.save
        format.html do
          redirect_to story_paragraph_url(@story_paragraph), notice: 'Story paragraph was successfully created.'
        end
        format.json { render :show, status: :created, location: @story_paragraph }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @story_paragraph.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /story_paragraphs/1 or /story_paragraphs/1.json
  def update
    respond_to do |format|
      if @story_paragraph.update(story_paragraph_params)
        format.html do
          redirect_to story_paragraph_url(@story_paragraph), notice: 'Story paragraph was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @story_paragraph }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @story_paragraph.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /story_paragraphs/1 or /story_paragraphs/1.json
  def destroy
    @story_paragraph.destroy

    respond_to do |format|
      format.html { redirect_to story_paragraphs_url, notice: 'Story paragraph was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def regenerate_images
    # @story_paragraph = StoryParagraph.find(params[:id])
    @story_paragraph.delete_all_images
  end

  def gen_audio
    @story_paragraph.generate_audio_transcript
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_story_paragraph
    @story_paragraph = StoryParagraph.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def story_paragraph_params
    params.require(:story_paragraph).permit(:story_index, :original_text, :genai_input_for_image, :internal_notes,
                                            :translated_text, :language, :story_id, :rating)
  end
end
