require 'rails_helper'

RSpec.describe WorksheetsController, type: :controller do
  let(:teacher)            { create(:teacher) }
  let(:student)            { create(:student) }
  let(:worksheet_template) { create(:worksheet, user: teacher) }
  let(:work_group)         { create(:work_group) }
  let(:student_work_group) { create(:student_work_group, user: student, work_group: work_group) }
  let(:worksheet1)         { create(:worksheet, work_group: work_group, worksheet_template: worksheet_template) }
  let(:worksheet2)         { create(:worksheet) }

  context 'student' do
    before do
      sign_in student
    end

    describe '#index' do
      context 'success' do
        it "lists worksheets belonging to student's work group" do
          worksheet1
          worksheet2
          get :index, format: :json, params: { work_group_id: work_group.id }
          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body).size).to eq(1)
        end
      end

      context 'failure' do
        it 'restricts worksheets belonging to other work groups' do
          get :index, format: :json, params: { work_group_id: worksheet2.work_group.id }
          expect(response).to have_http_status(401)
        end
      end
    end

    describe '#show' do
      context 'success' do
        it 'returns selected worksheet' do
          get :show, params: { id: worksheet1.id, format: :json }
          expect(response).to have_http_status(200)
          expect(response.body).to eq(worksheet1.to_json)
        end
      end

      context 'failure' do
        it 'returns 404 for missing worksheet' do
          get :show, params: { id: 999, format: :json }
          expect(response).to have_http_status(404)
        end

        it 'restricts worksheet belonging to other work group' do
          get :show, params: { id: worksheet2.id, format: :json }
          expect(response).to have_http_status(401)
        end
      end
    end

    describe '#edit' do
      context 'success' do
        it 'returns selected worksheet to modify' do
          get :edit, params: { id: worksheet1.id, format: :json }
          expect(response).to have_http_status(200)
          expect(response.body).to eq(worksheet1.to_json)
        end
      end

      context 'failure' do
        it 'returns 404 for missing worksheet' do
          get :edit, params: { id: 999, format: :json }
          expect(response).to have_http_status(404)
        end

        it 'restricts worksheet belonging to other work group' do
          get :edit, params: { id: worksheet2.id, format: :json }
          expect(response).to have_http_status(401)
        end
      end
    end

    describe '#update' do
      context 'success' do
        it 'changes selected worksheet' do
          patch :update, params: { id: worksheet1.id, worksheet: { name: 'New Test worksheet' }, format: :json }
          expect(response).to have_http_status(200)
          expect(response.body).to include('New Test')
        end
      end

      context 'failure' do
        it 'returns 404 for missing worksheet' do
          patch :update, params: { id: 999, worksheet: { name: 'New Test worksheet' }, format: :json }
          expect(response).to have_http_status(404)
        end

        it 'restricts worksheet belonging to other work group' do
          patch :update, params: { id: worksheet2.id, worksheet: { name: 'New Test worksheet' }, format: :json }
          expect(response).to have_http_status(401)
        end

        it 'raises an error with missing data' do
          patch :update, params: { id: worksheet1.id, worksheet: { name: nil }, format: :json }
          expect(response).to have_http_status(422)
          expect(response.body).to include('error')
        end
      end
    end

    describe '#new' do
      context 'success' do
        it 'returns blank worksheet' do
          get :new, format: :json, params: { work_group_id: work_group.id }
          expect(response).to have_http_status(200)
          expect(response.body).to eq(Worksheet.new.to_json)
        end
      end

      context 'failure' do
        it 'restricts creating a worksheet from a foreign work group' do
          get :new, format: :json, params: { work_group_id: worksheet2.work_group.id }
          expect(response).to have_http_status(401)
        end
      end
    end

    describe '#create' do
      context 'success' do
        it 'saves a new worksheet' do
          put :create, params: {
            work_group_id: work_group.id,
            worksheet: { name: 'Test Worksheet 1' },
            format: :json
          }
          expect(response).to have_http_status(200)
          expect(Worksheet.find_by_name('Test Worksheet 1')).to be_instance_of(Worksheet)
        end
      end

      context 'failure' do
        it 'raises an error with missing data' do
          put :create, params: {
            work_group_id: work_group.id,
            worksheet: { name: nil },
            format: :json
          }
          expect(response).to have_http_status(422)
          expect(response.body).to include('error')
        end

        it 'restricts creating a worksheet from a foreign work group' do
          put :create, params: {
            work_group_id: worksheet2.work_group.id,
            worksheet: { name: 'Test Worksheet 2' },
            format: :json
          }
          expect(response).to have_http_status(401)
        end
      end
    end

    describe '#destroy' do
      context 'success' do
        it 'deletes selected worksheet' do
          delete :destroy, params: { id: worksheet1.id, format: :json }
          expect(response).to have_http_status(200)
          expect(Worksheet.all).not_to include(worksheet1)
        end
      end

      context 'failure' do
        it 'restricts worksheet belonging to other teacher' do
          delete :destroy, params: { id: worksheet2.id, format: :json }
          expect(response).to have_http_status(401)
        end

        it 'returns 404 for missing worksheet' do
          delete :destroy, params: { id: 999, format: :json }
          expect(response).to have_http_status(404)
        end
      end
    end
  end
end
