class InvitationMailer < ApplicationMailer
  def demo_invite
    @user = params[:user]
    work_group = params[:work_group]
    @one_time_password = rand(36**10).to_s(36)
    @session_url = "https://odaiba-app.netlify.app/classrooms/#{work_group.classroom_id}/work_groups/#{work_group.id}"
    mail(to: @user.email, subject: 'demo') if @user.update(password: @one_time_password)
  end
end
