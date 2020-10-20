class ClassroomsController < ApplicationController
  def new
    @classroom = params[:classroom] ? Classroom.new(classroom_params) : Classroom.new
    if params[:no_model_fields]
      @teacher_email =  custom_params[:teacher_email]
      @student_emails = custom_params[:student_emails]
      @worksheet_urls = custom_params[:worksheet_urls]
    end
  end

  def create
    vars_for_mailer = ClassroomDemoPrepper.new(
      custom_params[:teacher_email],
      custom_params[:student_emails],
      custom_params[:worksheet_urls]
    ).call

    # vars_for_mailer[:teacher] -> deliver email to teacher
    vars_for_mailer[:students].each do |student|
      DemoMailer.with(user: student[:email], work_group: student[:work_group]).invite.deliver_later
    end
    redirect_to new_classroom_path, notice: 'Invitations sent'
  rescue StandardError => e
    redirect_with_params(e.message)
  end

  private

  def classroom_params
    params.require(:classroom).permit(:grade, :group, :subject)
  end

  def custom_params
    params.require(:no_model_fields).permit(:teacher_email, :student_emails, :worksheet_urls)
  end

  def redirect_with_params(message)
    redirect_to new_classroom_path(classroom: classroom_params, no_model_fields: custom_params), notice: message
  end
end
