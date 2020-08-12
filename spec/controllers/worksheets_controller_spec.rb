require 'rails_helper'

RSpec.describe WorksheetsController, type: :controller do
#   let(:teacher1)   { create(:teacher) }
#   let(:teacher2)   { create(:teacher) }
#   let(:worksheet1) { create(:worksheet, user: teacher1) }
#   let(:worksheet2) { create(:worksheet, user: teacher2) }
  let(:student1)            { create(:student) }
  let(:student2)            { create(:student) }
  let(:work_group1)         { create(:work_group) }
  let(:work_group2)         { create(:work_group) }
  let(:student_work_group1) { create(:student_work_group, user: student1, work_group: work_group1) }
  let(:student_work_group2) { create(:student_work_group, user: student2, work_group: work_group2) }
  let(:worksheet1)          { create(:worksheet, work_group: work_group1) }
  let(:worksheet2)          { create(:worksheet, work_group: work_group2) }

  context 'student' do
    before do
      sign_in student1
    end

    describe '#index' do
      it "lists worksheets belonging to student's work group" do
        worksheet1
        worksheet2
        get :index, format: :json
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).size).to eq(1)
      end
    end

    # describe '#show' do
    #   context 'success' do
    #     it 'returns selected classroom' do
    #       get :show, params: { id: classroom1.id, format: :json }
    #       expect(response).to have_http_status(200)
    #       expect(response.body).to eq(classroom1.to_json)
    #     end
    #   end

    #   context 'failure' do
    #     it 'returns 404 for missing classroom' do
    #       get :show, params: { id: 999, format: :json }
    #       expect(response).to have_http_status(404)
    #     end

    #     it 'restricts classroom belonging to other teacher' do
    #       get :show, params: { id: classroom2.id, format: :json }
    #       expect(response).to have_http_status(401)
    #     end
    #   end
    # end

    # describe '#edit' do
    #   context 'success' do
    #     it 'returns selected classroom to modify' do
    #       get :edit, params: { id: classroom1.id, format: :json }
    #       expect(response).to have_http_status(200)
    #       expect(response.body).to eq(classroom1.to_json)
    #     end
    #   end

    #   context 'failure' do
    #     it 'returns 404 for missing classroom' do
    #       get :edit, params: { id: 999, format: :json }
    #       expect(response).to have_http_status(404)
    #     end

    #     it 'restricts classroom belonging to other teacher' do
    #       get :edit, params: { id: classroom2.id, format: :json }
    #       expect(response).to have_http_status(401)
    #     end
    #   end
    # end

    # describe '#update' do
    #   context 'success' do
    #     it 'changes selected classroom' do
    #       patch :update, params: { id: classroom1.id, classroom: { name: 'New Test Classroom' }, format: :json }
    #       expect(response).to have_http_status(200)
    #       expect(response.body).to include('New Test')
    #     end
    #   end

    #   context 'failure' do
    #     it 'returns 404 for missing classroom' do
    #       patch :update, params: { id: 999, classroom: { name: 'New Test Classroom' }, format: :json }
    #       expect(response).to have_http_status(404)
    #     end

    #     it 'restricts classroom belonging to other teacher' do
    #       patch :update, params: { id: classroom2.id, classroom: { name: 'New Test Classroom' }, format: :json }
    #       expect(response).to have_http_status(401)
    #     end

    #     it 'raises an error with missing data' do
    #       patch :update, params: { id: classroom1.id, classroom: { name: nil }, format: :json }
    #       expect(response).to have_http_status(422)
    #       expect(response.body).to include('error')
    #     end
    #   end
    # end

    # describe '#new' do
    #   it 'returns blank classroom' do
    #     get :new, format: :json
    #     expect(response).to have_http_status(200)
    #   end
    # end

    # describe '#create' do
    #   context 'success' do
    #     it 'saves a new classroom' do
    #       put :create, params: { classroom: { name: 'Test Classroom 1' }, format: :json }
    #       expect(response).to have_http_status(200)
    #       expect(Classroom.find_by_name('Test Classroom 1')).to be_instance_of(Classroom)
    #     end
    #   end

    #   context 'failure' do
    #     it 'raises an error with missing data' do
    #       put :create, params: { classroom: { name: nil }, format: :json }
    #       expect(response).to have_http_status(422)
    #       expect(response.body).to include('error')
    #     end
    #   end
    # end

    # describe '#destroy' do
    #   context 'success' do
    #     it 'deletes selected classroom' do
    #       delete :destroy, params: { id: classroom1.id, format: :json }
    #       expect(response).to have_http_status(200)
    #       expect(Classroom.all).not_to include(classroom1)
    #     end
    #   end

    #   context 'failure' do
    #     it 'restricts classroom belonging to other teacher' do
    #       delete :destroy, params: { id: classroom2.id, format: :json }
    #       expect(response).to have_http_status(401)
    #     end

    #     it 'returns 404 for missing classroom' do
    #       delete :destroy, params: { id: 999, format: :json }
    #       expect(response).to have_http_status(404)
    #     end
    #   end
    # end
  end
end
