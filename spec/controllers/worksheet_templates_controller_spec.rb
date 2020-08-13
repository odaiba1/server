require 'rails_helper'

RSpec.describe WorksheetTemplatesController, type: :controller do
  let(:teacher)             { create(:teacher) }
  let(:worksheet_template1) { create(:worksheet_template, user: teacher) }
  let(:worksheet_template2) { create(:worksheet_template) }

  before do
    sign_in teacher
  end

  describe '#index' do
    it 'lists worksheet templates belonging to teacher' do
      worksheet_template1
      worksheet_template2
      get :index, format: :json
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).size).to eq(1)
    end
  end

  describe '#show' do
    context 'success' do
      it 'returns selected worksheet template' do
        get :show, params: { id: worksheet_template1.id, format: :json }
        expect(response).to have_http_status(200)
        expect(response.body).to eq(worksheet_template1.to_json)
      end
    end

    context 'failure' do
      it 'returns 404 for missing worksheet template' do
        get :show, params: { id: 999, format: :json }
        expect(response).to have_http_status(404)
      end

      it 'restricts worksheet template belonging to other teacher' do
        get :show, params: { id: worksheet_template2.id, format: :json }
        expect(response).to have_http_status(401)
      end
    end
  end

  describe '#edit' do
    context 'success' do
      it 'returns selected worksheet_template to modify' do
        get :edit, params: { id: worksheet_template1.id, format: :json }
        expect(response).to have_http_status(200)
        expect(response.body).to eq(worksheet_template1.to_json)
      end
    end

    context 'failure' do
      it 'returns 404 for missing worksheet_template' do
        get :edit, params: { id: 999, format: :json }
        expect(response).to have_http_status(404)
      end

      it 'restricts worksheet_template belonging to other teacher' do
        get :edit, params: { id: worksheet_template2.id, format: :json }
        expect(response).to have_http_status(401)
      end
    end
  end

  describe '#update' do
    context 'success' do
      it 'changes selected worksheet template' do
        patch :update, params: {
          id: worksheet_template1.id,
          worksheet_template: { title: 'New Test Worksheet Template' },
          format: :json
        }
        expect(response).to have_http_status(200)
        expect(response.body).to include('New Test')
      end
    end

    context 'failure' do
      it 'returns 404 for missing worksheet template' do
        patch :update, params: { id: 999, worksheet_template: { title: 'New Test Worksheet Template' }, format: :json }
        expect(response).to have_http_status(404)
      end

      it 'restricts worksheet template belonging to other teacher' do
        patch :update, params: {
          id: worksheet_template2.id,
          worksheet_template: { title: 'New Test Worksheet Template' },
          format: :json
        }
        expect(response).to have_http_status(401)
      end

      it 'raises an error with missing data' do
        patch :update, params: { id: worksheet_template1.id, worksheet_template: { title: nil }, format: :json }
        expect(response).to have_http_status(422)
        expect(response.body).to include('error')
      end
    end
  end

  describe '#new' do
    it 'returns blank worksheet template' do
      get :new, format: :json
      expect(response).to have_http_status(200)
      expect(response.body).to eq(WorksheetTemplate.new.to_json)
    end
  end

  describe '#create' do
    context 'success' do
      it 'saves a new worksheet template' do
        put :create, params: { worksheet_template: { title: 'Test Worksheet Template 1' }, format: :json }
        expect(response).to have_http_status(200)
        expect(WorksheetTemplate.find_by_title('Test Worksheet Template 1')).to be_instance_of(WorksheetTemplate)
      end
    end

    context 'failure' do
      it 'raises an error with missing data' do
        put :create, params: { worksheet_template: { title: nil }, format: :json }
        expect(response).to have_http_status(422)
        expect(response.body).to include('error')
      end
    end
  end

  describe '#destroy' do
    context 'success' do
      it 'deletes selected worksheet template' do
        delete :destroy, params: { id: worksheet_template1.id, format: :json }
        expect(response).to have_http_status(200)
        expect(WorksheetTemplate.all).not_to include(worksheet_template1)
      end
    end

    context 'failure' do
      it 'restricts worksheet template belonging to other teacher' do
        delete :destroy, params: { id: worksheet_template2.id, format: :json }
        expect(response).to have_http_status(401)
      end

      it 'returns 404 for missing worksheet template' do
        delete :destroy, params: { id: 999, format: :json }
        expect(response).to have_http_status(404)
      end
    end
  end
end
