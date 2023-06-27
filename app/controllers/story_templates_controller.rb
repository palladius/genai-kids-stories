class StoryTemplatesController < ApplicationController
  before_action :set_story_template, only: %i[ show edit update destroy ]

  # GET /story_templates or /story_templates.json
  def index
    @story_templates = StoryTemplate.all
  end

  # GET /story_templates/1 or /story_templates/1.json
  def show
  end

  # GET /story_templates/new
  def new
    @story_template = StoryTemplate.new
  end

  # GET /story_templates/1/edit
  def edit
  end

  # POST /story_templates or /story_templates.json
  def create
    @story_template = StoryTemplate.new(story_template_params)

    respond_to do |format|
      if @story_template.save
        format.html { redirect_to story_template_url(@story_template), notice: "Story template was successfully created." }
        format.json { render :show, status: :created, location: @story_template }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @story_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /story_templates/1 or /story_templates/1.json
  def update
    respond_to do |format|
      if @story_template.update(story_template_params)
        format.html { redirect_to story_template_url(@story_template), notice: "Story template was successfully updated." }
        format.json { render :show, status: :ok, location: @story_template }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @story_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /story_templates/1 or /story_templates/1.json
  def destroy
    @story_template.destroy

    respond_to do |format|
      format.html { redirect_to story_templates_url, notice: "Story template was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_story_template
      @story_template = StoryTemplate.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def story_template_params
      params.require(:story_template).permit(:short_code, :description, :template, :internal_notes, :user_id)
    end
end
