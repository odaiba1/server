class InvitationMailer < ApplicationMailer
  def demo_invite
    attachments.inline['odaiba-logo.png'] = File.read("#{Rails.root}/app/assets/images/odaiba-logo_inverted_icon.png")
    @user = params[:user]
    work_group = params[:work_group]
    @one_time_password = rand(36**10).to_s(36)
    env = Rails.env == 'production' ? 'https://odaiba-app.netlify.app' : 'http://localhost:3000'
    @session_url = "#{env}/classrooms/#{work_group.classroom_id}/work_groups/#{work_group.id}"
    return unless @user.update(password: @one_time_password)

    mail(to: @user.email, subject: 'You have been invited to an Odaiba demo session')
  end
end
