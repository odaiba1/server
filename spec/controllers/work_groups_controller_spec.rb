require 'rails_helper'

RSpec.describe WorkGroupsController, type: :controller do
  let(:teacher)     { create(:teacher, id: 1) }
  let(:student1)    { create(:student, id: 2) }
  let(:student2)    { create(:student, id: 3) }
  let(:classroom)   { create(:classroom, user: teacher) }
  let(:work_group1) { create(:work_group, classroom: classroom) }
  let(:student_work_group1) { create(:student_work_group1, student: student1, work_group: work_group1) }
  let(:student_work_group2) { create(:student_work_group2, student: student2, work_group: work_group1) }
  let(:worksheet_template) { create(:worksheet_template, user: teacher) }
  let(:worksheet_template2) { create(:worksheet_template, image_url: 'google.com', user: teacher) }
  let(:worksheet1) { create(:worksheet, work_group: work_group1, worksheet_template: worksheet_template) }
  let(:work_group_demo_prepper) { double(WorkGroupDemoPrepper) }
  let(:demo_mailer) { double(DemoMailer) }

  describe '#new' do
    context 'returns correct work group' do
      it 'with params' do
        worksheet1
        get :new, params: {
          work_group: { turn_time: 300_000 },
          no_model_fields: {
            emails: 'test1@gmail.com test2@gmail.com',
            worksheet_url: 'https://res.cloudinary.com/naokimi/image/upload/v1563422680/p7ojmgdtwshkrhxmjzh1.jpg',
            delivery_method: 'generate links',
            start_time: Time.now + 60_000,
            start_date: Date.today
          }
        }
        expect(controller.instance_variable_get(:@work_group).turn_time).to eq(300_000)
        expect(WorkGroup.find_by_turn_time(300_000)).to be_instance_of(WorkGroup)
        expect(controller.instance_variable_get(:@emails)).to eq('test1@gmail.com test2@gmail.com')
        expect(controller.instance_variable_get(:@delivery_method)).to eq('generate links')
        expect(controller.instance_variable_get(:@urls)).to eq('https://res.cloudinary.com/naokimi/image/upload/v1563422680/p7ojmgdtwshkrhxmjzh1.jpg')
      end

      it 'with no params' do
        get :new
        expect(controller.instance_variable_get(:@work_group).turn_time).to eq(nil)
      end
    end

    context 'returns correct worksheet urls' do
      it 'with correct url format' do
        worksheet_template
        get :new
        expect(controller.instance_variable_get(:@worksheet_urls)).to eq(['https://res.cloudinary.com/naokimi/image/upload/v1563422680/p7ojmgdtwshkrhxmjzh1.jpg'])
      end
      it 'with incorrect url format' do
        worksheet_template2
        get :new
        expect(controller.instance_variable_get(:@worksheet_urls)).to eq([])
      end
    end
  end

  describe '#create' do
    context 'success' do
      before do
        allow(WorkGroupDemoPrepper).to receive(:new).and_return(work_group_demo_prepper)
        allow(work_group_demo_prepper).to receive(:call).and_return({ users: [student1, student2], work_group: work_group1 })
        allow(DemoMailer).to receive(:with).and_return(demo_mailer)
        allow(demo_mailer).to receive(:invite).and_return(demo_mailer)
        allow(demo_mailer).to receive(:deliver_later).and_return(demo_mailer)
      end
      it 'returns correct email invitations' do
        post :create, params: {
          work_group: { turn_time: 300_000},
          no_model_fields: {
            emails: "#{student1.email} #{student2.email}",
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
          work_group: { turn_time: 300_000},
          no_model_fields: {
            emails: "#{student1.email} #{student2.email}",
            worksheet_url: 'https://res.cloudinary.com/naokimi/image/upload/v1563422680/p7ojmgdtwshkrhxmjzh1.jpg',
            delivery_method: 'generate links',
            start_time: Time.now + 1.hour,
            start_date: Date.today
          }
        }
        expect(response).to have_http_status(302)
        expect(response.location).to include(CGI.escape("---#{student2.email}"))
      end
    end

    context 'failure' do
      before do
        allow(WorkGroupDemoPrepper).to receive(:new).and_return(work_group_demo_prepper)
        allow(work_group_demo_prepper).to receive(:call)
      end
      it 'has less than 2 email addresses' do
        student1
        post :create, params: {
          work_group: { turn_time: 300_000},
          no_model_fields: {
            emails: student1.email.to_s
          }
        }
        expect(response).to have_http_status(302)
        expect(response.location).to include(CGI.escape('Please input at least 2 email addresses'))
      end

      it 'nonexistent delivery method' do
        classroom
        put :create, params: {
          work_group: { turn_time: 300_000},
          no_model_fields: {
            emails: "#{student1.email} #{student2.email}",
            worksheet_url: 'https://res.cloudinary.com/naokimi/image/upload/v1563422680/p7ojmgdtwshkrhxmjzh1.jpg',
            start_time: Time.now + 1.hour,
            start_date: Date.today
          }
        }
        expect(response).to have_http_status(302)
        expect(response.location).to include(CGI.escape('Please select a delivery method'))
      end

      it 'raise error for invalid start time' do
        put :create, params: {
          work_group: { turn_time: 300_000},
          no_model_fields: {
            emails: "#{student1.email} #{student2.email}",
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
