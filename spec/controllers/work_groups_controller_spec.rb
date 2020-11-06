require 'rails_helper'

RSpec.describe WorkGroupsController, type: :controller do
  let(:work_group)              { create(:work_group) }
  let(:student_work_group1)     { create(:student_work_group, work_group: work_group) }
  let(:student_work_group2)     { create(:student_work_group, work_group: work_group) }
  let(:worksheet_template2)     { create(:worksheet_template, image_url: 'google.com') }
  let(:worksheet)               { create(:worksheet) }
  let(:work_group_demo_prepper) { double(WorkGroupDemoPrepper) }
  let(:demo_mailer)             { double(DemoMailer) }
  let(:params)                  { nil }

  describe '#new' do
    subject { get :new, params: params }

    context 'with params' do
      let(:params) do
        {
          work_group: { turn_time: 300_000 },
          no_model_fields: {
            emails: 'test1@gmail.com test2@gmail.com',
            worksheet_url: 'https://res.cloudinary.com/naokimi/image/upload/v1563422680/p7ojmgdtwshkrhxmjzh1.jpg',
            delivery_method: 'generate links',
            start_time: Time.now + 60_000,
            start_date: Date.today
          }
        }
      end

      it 'renders template with instance variables' do
        worksheet
        expect(subject).to have_http_status(200)
        expect(WorkGroup.find_by_turn_time(300_000)).to be_instance_of(WorkGroup)
        expect(controller.instance_variable_get(:@emails)).to eq('test1@gmail.com test2@gmail.com')
        expect(controller.instance_variable_get(:@delivery_method)).to eq('generate links')
        expect(controller.instance_variable_get(:@urls)).to eq('https://res.cloudinary.com/naokimi/image/upload/v1563422680/p7ojmgdtwshkrhxmjzh1.jpg')
        expect(controller.instance_variable_get(:@worksheet_urls)).to eq(['https://res.cloudinary.com/naokimi/image/upload/v1563422680/p7ojmgdtwshkrhxmjzh1.jpg'])
      end
    end

    context 'with no params' do
      it 'render template' do
        worksheet_template2
        get :new
        expect(controller.instance_variable_get(:@work_group).turn_time).to eq(nil)
        expect(controller.instance_variable_get(:@worksheet_urls)).to eq([])
      end
    end
  end

  describe '#create' do
    context 'success' do
      before do
        allow(WorkGroupDemoPrepper).to receive(:new).and_return(work_group_demo_prepper)
        allow(work_group_demo_prepper).to receive(:call).and_return(
          { users: [student_work_group1.student, student_work_group2.student], work_group: work_group }
        )
        allow(DemoMailer).to receive_message_chain(:with, :invite, :deliver_later)
      end
      it 'sends email invitations' do
        post :create, params: {
          work_group: { turn_time: 300_000 },
          no_model_fields: {
            emails: "#{student_work_group1.student.email} #{student_work_group2.student.email}",
            worksheet_url: 'https://res.cloudinary.com/naokimi/image/upload/v1563422680/p7ojmgdtwshkrhxmjzh1.jpg',
            delivery_method: 'send email',
            start_time: Time.now + 1.hour,
            start_date: Date.today
          }
        }
        expect(response).to have_http_status(302)
        expect(response.location).to include(CGI.escape('Invitations sent'))
      end
      it 'returns generated links' do
        post :create, params: {
          work_group: { turn_time: 300_000 },
          no_model_fields: {
            emails: "#{student_work_group1.student.email} #{student_work_group2.student.email}",
            worksheet_url: 'https://res.cloudinary.com/naokimi/image/upload/v1563422680/p7ojmgdtwshkrhxmjzh1.jpg',
            delivery_method: 'generate links',
            start_time: Time.now + 1.hour,
            start_date: Date.today
          }
        }
        expect(response).to have_http_status(302)
        expect(response.location).to include(CGI.escape("---#{student_work_group2.student.email}"))
      end
    end

    context 'failure' do
      before do
        allow(WorkGroupDemoPrepper).to receive(:new).and_return(work_group_demo_prepper)
        allow(work_group_demo_prepper).to receive(:call)
      end

      it 'has less than 2 email addresses' do
        post :create, params: {
          work_group: { turn_time: 300_000 },
          no_model_fields: {
            emails: student_work_group1.student.email.to_s
          }
        }
        expect(response).to have_http_status(302)
        expect(response.location).to include(CGI.escape('Please input at least 2 email addresses'))
      end

      it 'nonexistent delivery method' do
        post :create, params: {
          work_group: { turn_time: 300_000 },
          no_model_fields: {
            emails: "#{student_work_group1.student.email} #{student_work_group2.student.email}",
            worksheet_url: 'https://res.cloudinary.com/naokimi/image/upload/v1563422680/p7ojmgdtwshkrhxmjzh1.jpg',
            start_time: Time.now + 1.hour,
            start_date: Date.today
          }
        }
        expect(response).to have_http_status(302)
        expect(response.location).to include(CGI.escape('Please select a delivery method'))
      end

      it 'raise error for invalid start time' do
        post :create, params: {
          work_group: { turn_time: 300_000 },
          no_model_fields: {
            emails: "#{student_work_group1.student.email} #{student_work_group2.student.email}",
            worksheet_url: 'https://res.cloudinary.com/naokimi/image/upload/v1563422680/p7ojmgdtwshkrhxmjzh1.jpg',
            delivery_method: 'send email',
            start_time: Time.now + 1.day,
            start_date: Date.today
          }
        }
        expect(response).to have_http_status(302)
        expect { create }.to raise_error(StandardError)
      end
    end
  end
end
