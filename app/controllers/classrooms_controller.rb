class ClassroomsController < ApplicationController
  def new
    @classroom = params[:classroom] ? Classroom.new(classroom_params) : Classroom.new
    @notice = params[:notice]
    return unless params[:no_model_fields]

    @teacher_email =  custom_params[:teacher_email]
    @student_emails = custom_params[:student_emails]
    @worksheet_urls = custom_params[:worksheet_urls]
  end

  def create
    vars_for_mailer = ClassroomDemoPrepper.new(
      custom_params[:teacher_email],
      custom_params[:student_emails],
      custom_params[:worksheet_urls]
    ).call

    send_emails(vars_for_mailer)

    redirect_to new_classroom_path(notice: 'Invitations sent')
  rescue StandardError => e
    redirect_with_params(e.message)
  end

  private

  def classroom_params
    # params.require(:classroom).permit(:grade, :group, :subject) # TODO: will uncomment after we start passing classroom params
  end

  def custom_params
    params.require(:no_model_fields).permit(:teacher_email, :student_emails, :worksheet_urls)
  end

  def redirect_with_params(message)
    redirect_to new_classroom_path(classroom: classroom_params, no_model_fields: custom_params, notice: message)
  end

  def send_emails(vars_for_mailer)
    DemoMailer.with(
      teacher: vars_for_mailer[:teacher],
      work_groups_hash: vars_for_mailer[:work_groups]
    ).invite_teacher.deliver_later

    vars_for_mailer[:work_groups].each do |hash|
      hash[:students].each do |student|
        DemoMailer.with(user: student, work_group: hash[:work_group]).invite.deliver_later
      end
    end
  end
end
