class DemoMailer < ApplicationMailer
  def invite
    attachments.inline["odaiba-logo_inverted_icon.png"] = File.read("#{Rails.root}/app/assets/images/odaiba-logo_inverted_icon.png")
    @user = params[:user]
    work_group = params[:work_group]
    @one_time_password = rand(36**10).to_s(36)
    @session_url = "https://odaiba-app.netlify.app/classrooms/#{work_group.classroom_id}/work_groups/#{work_group.id}"
    return unless @user.update(password: @one_time_password)

    mail(to: @user.email, subject: 'You have been invited to an Odaiba demo session')
  end

  def send_worksheets
    students = params[:students]
    image_url = params[:image_url]
    teacher = params[:teacher]
    
    mail(to: students.map(&:email), subject: 'Hello World')
    # mail(to: students.map(&:email) << teacher.email, subject: 'Hello World')
  end
end
