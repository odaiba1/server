# Preview all emails at http://localhost:3000/rails/mailers/invitation_mailer
class InvitationMailerPreview < ActionMailer::Preview
  def demo_invite
    InvitationMailer.demo_invite
  end
end
