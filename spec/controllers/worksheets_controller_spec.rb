require 'rails_helper'

RSpec.describe WorksheetsController, type: :controller do
#   let(:teacher1)   { create(:teacher) }
#   let(:teacher2)   { create(:teacher) }
#   let(:worksheet1) { create(:worksheet, user: teacher1) }
#   let(:worksheet2) { create(:worksheet, user: teacher2) }
  let(:student1) { create(:student) }

  context 'student' do
    before do
      sign_in student1
    end

  #   describe '#index' do
  #     it 'lists worksheets belonging to teacher' do
  #       get :index, format: :json
  #       expect(response).to have_http_status(200)
  #       expect(response.body.size).to eq(1)
  #     end
  #   end

  #   describe '#show' do
  #     context 'success' do
  #       it 'returns selected worksheet' do
  #         get :show, params: { id: worksheet1.id, format: :json }
  #         expect(response).to have_http_status(200)
  #         expect(response.body).to eq(worksheet1.to_json)
  #       end
  #     end

  #     context 'failure' do
  #       it 'returns 404 for missing worksheet' do
  #         get :show, params: { id: 999, format: :json }
  #         expect(response).to have_http_status(404)
  #       end

  #       it 'restricts worksheet belonging to other teacher' do
  #         get :show, params: { id: worksheet2.id, format: :json }
  #         expect(response).to have_http_status(403)
  #       end
  #     end
  #   end

  #   describe '#edit' do
  #     context 'success' do
  #       it 'returns selected worksheet to modify' do
  #         get :edit, params: { id: worksheet1.id, format: :json }
  #         expect(response).to have_http_status(200)
  #         expect(response.body).to eq(worksheet1.to_json)
  #       end
  #     end

  #     context 'failure' do
  #       it 'returns 404 for missing worksheet' do
  #         get :edit, params: { id: 999, format: :json }
  #         expect(response).to have_http_status(404)
  #       end

  #       it 'restricts worksheet belonging to other teacher' do
  #         get :edit, params: { id: worksheet2.id, format: :json }
  #         expect(response).to have_http_status(403)
  #       end
  #     end
  #   end

  #   describe '#update' do
  #     context 'success' do
  #       it 'changes selected worksheet' do
  #         get :update, params: { id: worksheet1.id, name: 'New Test', format: :json }
  #         expect(response).to have_http_status(200)
  #         expect(response.body).to include('New Test')
  #       end
  #     end

  #     context 'failure' do
  #       it 'returns 404 for missing worksheet' do
  #         get :edit, params: { id: 999, name: 'New Test', format: :json }
  #         expect(response).to have_http_status(404)
  #       end

  #       it 'restricts worksheet belonging to other teacher' do
  #         get :update, params: { id: worksheet2.id, name: 'New Test', format: :json }
  #         expect(response).to have_http_status(403)
  #       end

  #       it 'raises an error with missing data' do
  #         get :update, params: { id: worksheet1.id, name: nil, format: :json }
  #         expect(response).to have_http_status(400)
  #         expecte(response.body).to include('error')
  #       end
  #     end
  #   end

  #   describe '#create' do
  #     context 'success' do
  #       it 'saves a new worksheet' do
  #         get :create, params: { name: 'Test1', format: :json }
  #         expect(response).to have_http_status(200)
  #         expect(Worksheet.find_by_name('Test1')).to be_instance_of(Worksheet)
  #       end
  #     end

  #     context 'failure' do
  #       it 'raises an error with missing data' do
  #         get :create, params: { name: nil, format: :json }
  #         expect(response).to have_http_status(400)
  #         expecte(response.body).to include('error')
  #       end
  #     end
  #   end

  #   describe '#new' do
  #     it 'returns blank worksheet' do
  #       get :new, format: :json
  #       expect(response).to have_http_status(200)
  #     end
  #   end

  #   describe '#delete' do
  #     context 'success' do
  #       it 'deletes selected worksheet' do
  #         get :delete, params: { id: worksheet1.id, format: :json }
  #         expect(response).to have_http_status(200)
  #         expect(Worksheet.all).not_to include(worksheet1)
  #       end
  #     end

  #     context 'failure' do
  #       it 'restricts worksheet belonging to other teacher' do
  #         get :delete, params: { id: worksheet2.id, format: :json }
  #         expect(response).to have_http_status(403)
  #       end
  #     end
  #   end
  end
end
