require 'rails_helper'

RSpec.describe DemoMailer, type: :mailer do
  context 'invite student' do
    let(:student_work_group) { create(:student_work_group) }
    let(:user)               { student_work_group.student }
    let(:work_group)         { student_work_group.work_group }
    subject do
      DemoMailer.with(
        user: user,
        work_group: work_group
      ).invite
    end

    it 'renders the subject' do
      expect(subject.subject).to eql('You have been invited to an Odaiba demo session')
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
        "http://localhost:3000/classrooms/#{work_group.classroom_id}/work_groups/#{work_group.id}"
      )
    end
  end

  context 'send worksheets' do
    let(:work_group)         { create(:work_group) }
    let(:student_work_group) { create(:student_work_group, work_group: work_group) }
    let(:worksheet)          { create(:worksheet, work_group: work_group, image_url: 'https://res.cloudinary.com/naokimi/image/upload/v1563422680/p7ojmgdtwshkrhxmjzh1.jpg') }
    let(:user_email)         { student_work_group.student.email }
    let(:image_urls)         { [worksheet.image_url] }
    subject do
      DemoMailer.with(
        students: user_email,
        student_group: work_group,
        image_urls: image_urls
      ).send_worksheets
    end

    it 'renders the subject' do
      expect(subject.subject).to eql("[Odaiba: #{work_group.name}] Successfully submitted worksheet")
    end

    it 'renders the receiver email' do
      expect(subject.to).to eql([user_email])
    end

    it 'renders the sender email' do
      expect(subject.from).to eql(['infoodaiba@gmail.com'])
    end

    it 'renders the image url' do
      expect(subject.body.encoded).to match('https://res.cloudinary.com/naokimi/image/upload/v1563422680/p7ojmgdtwshkrhxmjzh1.jpg')
    end
  end
end
