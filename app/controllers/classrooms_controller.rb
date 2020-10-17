class ClassroomsController < ApplicationController
  def new
    @classroom = params[:classroom] ? Classroom.new(classroom_params) : Classroom.new
    if params[:no_model_fields]
    end
  end

  def create
    # find or create teacher
    # find or create teacher's classroom (use params or default values)
    # find or create students
    # assign students to the classroom
    # create work groups using individual_time and name "demo session group nr."
    # separate students into workgroups based on group size
    # send email or generate links
  end

  private

  def classroom_params
    params.require(:classroom).permit(:grade, :group, :subject)
  end

  def custom_params
    params.require(:no_model_fields).permit(:teacher_email, :student_emails, :worksheet_templates)
  end
end
