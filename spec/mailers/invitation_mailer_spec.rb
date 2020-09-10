require 'rails_helper'

RSpec.describe InvitationMailer, type: :mailer do
  context 'demo mailer' do
    let(:student_work_group) { create(:student_work_group) }
    let(:user)               { student_work_group.student }
    let(:work_group)         { student_work_group.work_group }
    subject do
      InvitationMailer.with(
        user: user,
        work_group: work_group
      ).demo_invite
    end

    it 'renders the subject' do
      expect(subject.subject).to eql('demo')
    end

    it 'renders the receiver email' do
      expect(subject.to).to eql([user.email])
    end

    it 'renders the sender email' do
      expect(subject.from).to eql(['infoodaiba@gmail.com'])
    end

    it 'assigns temporary password' do
      # TODO: implement
    end

    it 'assigns @confirmation_url' do
      expect(subject.body.encoded).to match(
        "https://odaiba-app.netlify.app/classrooms/#{work_group.classroom_id}/work_groups/#{work_group.id}"
      )
    end
  end
end
