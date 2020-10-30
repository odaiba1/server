require 'rails_helper'

RSpec.describe WorkGroupsController, type: :controller do

  let(:teacher)     { create(:teacher) }
  let(:student1)    { create(:student) }
  let(:student2)    { create(:student) }
  let(:classroom)   { create(:classroom, user: teacher) }
  let(:work_group1) { create(:work_group, classroom: classroom) }
  let(:worksheet_template) { create(:worksheet_template, user: teacher) }
  # let(:worksheet_template2) { create(:worksheet_template, image_url: 'google.com', user: teacher) }
  let(:worksheet1) { create(:worksheet, work_group: work_group1, worksheet_template: worksheet_template) }

  before do
    request.headers['X-User-Email'] = teacher.email
    request.headers['X-User-Token'] = teacher.authentication_token
  end

  describe 'GET #new' do
    context 'success' do
      it 'assigns correct new work group with params' do
        worksheet1
        put :new, params: {
          work_group: { turn_time: 300_000 },
          no_model_fields: {
            emails: 'test1@gmail.com test2@gmail.com',
            worksheet_url: 'https://res.cloudinary.com/naokimi/image/upload/v1563422680/p7ojmgdtwshkrhxmjzh1.jpg',
            start_time: DateTime.now + 1.day,
            start_date: Date.today
          }
        }
        expect(controller.instance_variable_get(:@work_group).turn_time).to eq(300_000)
        expect(WorkGroup.find_by_turn_time(300_000)).to be_instance_of(WorkGroup)
        expect(controller.instance_variable_get(:@worksheet_urls)).to eq(['https://res.cloudinary.com/naokimi/image/upload/v1563422680/p7ojmgdtwshkrhxmjzh1.jpg'])
        expect(response).to have_http_status(:success)
      end

      it 'assigns correct new work group given no params' do
        worksheet1
        get :new
        # expect(controller.instance_variable_get(:@work_group).turn_time).to eq(nil)
        expect(controller.instance_variable_get(:@worksheet_urls)).to eq(['https://res.cloudinary.com/naokimi/image/upload/v1563422680/p7ojmgdtwshkrhxmjzh1.jpg'])
        expect(response).to have_http_status(:success)
      end
    end

    it 'Worksheet has wrong url and returns empty' do
      # worksheet_template2
      get :new
      expect(controller.instance_variable_get(:@worksheet_urls)).to eq([])
      expect(response).to have_http_status(:success)
    end

  describe 'GET #create' do
    context 'success' do
      it 'returns correct invitations and https success for existing students' do
        student1
        student2
        classroom
        put :create, params: {
          work_group: { turn_time: 300_000},
          no_model_fields: {
            emails: "#{student1.email} #{student2.email}",
            worksheet_url: 'https://res.cloudinary.com/naokimi/image/upload/v1563422680/p7ojmgdtwshkrhxmjzh1.jpg',
            start_time: DateTime.now + 1.day,
            start_date: Date.today
          }
        }
        expect(flash[:notice]).to match('Invitations sent')
      end

      it 'returns correct invitations and https success for new students' do
        classroom
        put :create, params: {
          work_group: { turn_time: 300_000},
          no_model_fields: {
            emails: 'susan111@gmail.com philip222@gmail.com',
            worksheet_url: 'https://res.cloudinary.com/naokimi/image/upload/v1563422680/p7ojmgdtwshkrhxmjzh1.jpg',
            start_time: DateTime.now + 1.day,
            start_date: Date.today
          }
        }
        expect(flash[:notice]).to match('Invitations sent')
      end
    end

    context 'failure' do
      it 'has less than 2 email addresses' do
        student1
        put :create, params: {
          work_group: { turn_time: 300_000},
          no_model_fields: {
            emails: student1.email.to_s
          }
        }
        expect(response).to redirect_to new_work_group_path(work_group: { turn_time: 300_000}, no_model_fields:  {
                                                              emails: student1.email.to_s
                                                            })
        expect(flash[:notice]).to match('Please input at least 2 email addresses')
      end

      it 'incorrect vars for mailer' do
        student1
        student2
        classroom
        put :create, params: {
          work_group: { turn_time: 300_000},
          no_model_fields: {
            emails: "#{student1.email} #{student2.email}",
            worksheet_url: 'https://res.cloudinary.com/naokimi/image/upload/v1563422680/p7ojmgdtwshkrhxmjzh1.jpg',
            start_date: Date.today
          }
        }
        expect { create }.to raise_error(StandardError)
      end
    end

  end
end
