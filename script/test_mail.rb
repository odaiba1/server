InvitationMailer.with(user: User.last, work_group: WorkGroup.last).demo_invite.deliver_now
