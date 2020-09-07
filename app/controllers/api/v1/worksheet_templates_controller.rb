class Api::V1::WorksheetTemplatesController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User
  before_action :set_worksheet_template, only: %i[show edit update destroy]

  def index
    @worksheet_templates = policy_scope(WorksheetTemplate)
    render json: @worksheet_templates.to_json
  end

  def show
    render json: @worksheet_template.to_json
  end

  def edit
    render json: @worksheet_template.to_json
  end

  def update
    image_url = remote_image_url
    prepped_params = worksheet_template_params.slice(:image_url, :photo).merge({ image_url: image_url })
    if @worksheet_template.update(prepped_params)
      render json: @worksheet_template.to_json
    else
      render_error
    end
  end

  def new
    @worksheet_template = WorksheetTemplate.new
    authorize @worksheet_template
    render json: @worksheet_template.to_json
  end

  def create
    @worksheet_template = WorksheetTemplate.new(worksheet_template_params)
    @worksheet_template.user = current_user
    @worksheet_template.image_url = remote_image_url
    authorize @worksheet_template
    if @worksheet_template.save
      render json: @worksheet_template.to_json
    else
      render_error
    end
  end

  def destroy
    @worksheet_template.destroy
    render json: {}
  end

  private

  def remote_image_url
    prms = params[:worksheet_template]
    CloudinaryUploader.new(prms[:image_url], prms[:photo]).call
  end

  def set_worksheet_template
    @worksheet_template = WorksheetTemplate.find(params[:id])
    authorize @worksheet_template
  end

  def worksheet_template_params
    params.require(:worksheet_template).permit(:title, :image_url)
  end

  def render_error
    render json: { errors: @worksheet_template.errors.full_messages },
           status: :unprocessable_entity
  end
end
