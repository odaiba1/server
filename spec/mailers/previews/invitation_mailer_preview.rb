# Preview all emails at http://localhost:3000/rails/mailers/invitation_mailer
class InvitationMailerPreview < ActionMailer::Preview
  def demo_invite
    attachments.inline['odaiba-logo_inverted_icon.png'] = File.read('/assets/images/odaiba-logo_inverted_icon.png')
  end
end
