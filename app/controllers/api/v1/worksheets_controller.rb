class Api::V1::WorksheetsController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User
  before_action :set_and_authorize_work_group, only: %i[new create index]
  before_action :set_and_authorize_worksheet, only: %i[show edit update]
  after_action :verify_authorized, except: %i[index dashboard_index]

  def dashboard_index
    @worksheets = WorksheetPolicy::Scope.new(current_user, Worksheet).dashboard_scope
    render json: @worksheets.map(&:parse_for_dashboard).to_json
  end

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
    @image_url = remote_image_url
    prepped_params = worksheet_params.except(:image_url, :photo).merge({ image_url: @image_url })
    if @worksheet.update(prepped_params)
      if !@worksheet.work_group.worksheet_email_sent &&
         @worksheet.work_group.classroom.teacher == User.where(role: 'teacher').first
        mail_worksheets
      end
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
    @worksheet.template_image_url = WorksheetTemplate.find(@worksheet.worksheet_template_id).image_url
    @worksheet.image_url = remote_image_url
    @worksheet.work_group = @work_group
    authorize @worksheet
    if @worksheet.save
      render json: @worksheet.to_json
    else
      render_error
    end
  end

  private

  def remote_image_url
    prms = params[:worksheet]
    CloudinaryUploader.new(prms[:image_url], prms[:photo]).call
  end

  def mail_worksheets
    students = @worksheet.work_group.students.pluck(:email)
    student_group = @worksheet.work_group
    DemoMailer.with(
      students: students,
      student_group: student_group,
      image_url: @image_url
    ).send_worksheets.deliver_later
    @worksheet.work_group.update(worksheet_email_sent: true)
  end

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
