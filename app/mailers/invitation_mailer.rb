class InvitationMailer < ApplicationMailer
  def demo_invite(users)
    users.each do |user|
      mail(to: user.email, subject: 'demo')
    end
  end
end
