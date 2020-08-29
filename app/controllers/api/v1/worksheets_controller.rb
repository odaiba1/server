class Api::V1::WorksheetsController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User
  before_action :set_and_authorize_work_group, only: %i[new create index]
  before_action :set_and_authorize_worksheet, only: %i[show edit update]

  def index
    @worksheets = policy_scope(Worksheet)
    render json: @worksheets.to_json
  end

  def show
    render json: @worksheet.to_json
  end

  def edit
    render json: @worksheet.to_json
  end

  def update
    if @worksheet.update(worksheet_params)
      render json: @worksheet.to_json
    else
      render_error
    end
  end

  def new
    @worksheet = Worksheet.new
    authorize @worksheet
    render json: @worksheet.to_json
  end

  def create
    @worksheet = Worksheet.new(worksheet_params)
    # OPTIMIZE: make it more readable
    @worksheet.template_image_url = WorksheetTemplate.find(@worksheet.worksheet_template_id).image_url
    if @worksheet.image_url.nil? && params[:worksheet][:photo]
      image = Cloudinary::Uploader.upload(params[:worksheet][:photo])
      @worksheet.image_url = image
    end
    @worksheet.work_group = @work_group
    authorize @worksheet
    if @worksheet.save
      render json: @worksheet.to_json
    else
      render_error
    end
  end

  private

  def set_and_authorize_worksheet
    @worksheet = Worksheet.find(params[:id])
    authorize @worksheet
  end

  def worksheet_params
    params.require(:worksheet).permit(:title, :work_group_id, :worksheet_template_id, :canvas, :image_url)
  end

  def set_and_authorize_work_group
    @work_group = WorkGroup.find(params[:work_group_id])
    authorize @work_group, :show?
  end

  def render_error
    render json: { errors: @worksheet.errors.full_messages },
           status: :unprocessable_entity
  end
end
