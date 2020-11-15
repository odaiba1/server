class DemoMailer < ApplicationMailer
  def invite
    odaiba_logo
    @user = params[:user]
    work_group = params[:work_group]
    @session_url = work_group.minified_url(@user)

    mail(to: @user.email, subject: 'You have been invited to an Odaiba demo session')
  end

  def invite_teacher
    odaiba_logo
    @teacher = params[:teacher]
    classroom = @teacher.classrooms.last
    @classroom_url = classroom.minified_url_for_teacher(@teacher)
    @work_groups_hash = params[:work_groups_hash]

    mail(to: @teacher.email, subject: 'Your Odaiba classroom is ready')
  end

  def send_worksheets
    odaiba_logo
    students_email = params[:students]
    @student_group = params[:student_group]
    @image_urls = params[:image_urls]
    mail(to: students_email, subject: "[Odaiba: #{@student_group.name}] Successfully submitted worksheet")
  end

  def send_worksheets_to_teacher
    odaiba_logo
    @teacher = params[:teacher]
    @work_groups = params[:work_groups]
    mail(to: @teacher.email, subject: 'Your Odaiba classroom is concluded')
  end

  private

  def odaiba_logo
    attachments.inline['odaiba-logo.png'] = File.read("#{Rails.root}/app/assets/images/odaiba-logo_inverted_icon.png")
  end
end
