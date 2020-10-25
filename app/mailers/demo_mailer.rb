class DemoMailer < ApplicationMailer
  def invite
    attachments.inline['odaiba-logo.png'] = File.read("#{Rails.root}/app/assets/images/odaiba-logo_inverted_icon.png")
    @user = params[:user]
    work_group = params[:work_group]
    @session_url = work_group.minified_url(@user)

    mail(to: @user.email, subject: 'You have been invited to an Odaiba demo session')
  end

  def send_worksheets
    attachments.inline['odaiba-logo.png'] = File.read("#{Rails.root}/app/assets/images/odaiba-logo_inverted_icon.png")
    students_email = params[:students]
    @student_group = params[:student_group]
    @image_url = params[:image_url]
    # teacher_email = params[:teacher]
    mail(to: students_email, subject: "[Odaiba: #{@student_group.name}] Successfully submitted worksheet")
    # mail(to: teacher, cc: students, subject: 'Hello World')
  end
end
