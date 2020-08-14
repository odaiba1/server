class WorksheetsController < ApplicationController
  acts_as_token_authentication_handler_for User
  before_action :set_and_authorize_work_group, only: %i[new create index]
  before_action :set_and_authorize_worksheet, only: %i[show edit update]

  def index
    @worksheets = policy_scope(Worksheet)
    render json: @worksheets.to_json
    response.headers['X-AUTH-TOKEN'] = current_user.authentication_token
  end

  def show
    render json: @worksheet.to_json
    response.headers['X-AUTH-TOKEN'] = current_user.authentication_token
  end

  def edit
    render json: @worksheet.to_json
    response.headers['X-AUTH-TOKEN'] = current_user.authentication_token
  end

  def update
    if @worksheet.update(worksheet_params)
      render json: @worksheet.to_json
    else
      render_error
    end
    response.headers['X-AUTH-TOKEN'] = current_user.authentication_token
  end

  def new
    @worksheet = Worksheet.new
    authorize @worksheet
    render json: @worksheet.to_json
    response.headers['X-AUTH-TOKEN'] = current_user.authentication_token
  end

  def create
    @worksheet = Worksheet.new(worksheet_params)
    authorize @worksheet
    render json: @worksheet.to_json
    response.headers['X-AUTH-TOKEN'] = current_user.authentication_token
  end

  private

  def set_and_authorize_worksheet
    @worksheet = Worksheet.find(params[:id])
    authorize @worksheet
  end

  def worksheet_params
    params.require(:worksheet).permit(:title, :work_group_id, :worksheet_template_id, :photo)
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
