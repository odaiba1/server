require 'rails_helper'

RSpec.describe ClassroomsController, type: :controller do
  let(:teacher1)   { FactoryBot.create(:teacher) }
  let(:teacher2)   { FactoryBot.create(:teacher) }
  let(:classroom1) { FactoryBot.create(:classroom, user: teacher1) }
  let(:classroom2) { FactoryBot.create(:classroom, user: teacher2) }

  before do
    sign_in teacher1
  end

  describe '#index' do
    it 'lists classrooms belonging to teacher' do
      classroom1
      classroom2
      get :index, format: :json
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).size).to eq(1)
    end
  end

  describe '#show' do
    context 'success' do
      it 'returns selected classroom' do
        get :show, params: { id: classroom1.id, format: :json }
        expect(response).to have_http_status(200)
        expect(response.body).to eq(classroom1.to_json)
      end
    end

    context 'failure' do
      it 'returns 404 for missing classroom' do
        get :show, params: { id: 999, format: :json }
        expect(response).to have_http_status(404)
      end

      it 'restricts classroom belonging to other teacher' do
        get :show, params: { id: classroom2.id, format: :json }
        expect(response).to have_http_status(401)
      end
    end
  end

  describe '#edit' do
    context 'success' do
      it 'returns selected classroom to modify' do
        get :edit, params: { id: classroom1.id, format: :json }
        expect(response).to have_http_status(200)
        expect(response.body).to eq(classroom1.to_json)
      end
    end

    context 'failure' do
      it 'returns 404 for missing classroom' do
        get :edit, params: { id: 999, format: :json }
        expect(response).to have_http_status(404)
      end

      it 'restricts classroom belonging to other teacher' do
        get :edit, params: { id: classroom2.id, format: :json }
        expect(response).to have_http_status(401)
      end
    end
  end

  describe '#update' do
    context 'success' do
      it 'changes selected classroom' do
        get :update, params: { id: classroom1.id, classroom: { name: 'New Test Classroom' }, format: :json }
        expect(response).to have_http_status(200)
        expect(response.body).to include('New Test')
      end
    end

    context 'failure' do
      it 'returns 404 for missing classroom' do
        get :update, params: { id: 999, classroom: { name: 'New Test Classroom' }, format: :json }
        expect(response).to have_http_status(404)
      end

      it 'restricts classroom belonging to other teacher' do
        get :update, params: { id: classroom2.id, classroom: { name: 'New Test Classroom' }, format: :json }
        expect(response).to have_http_status(401)
      end

      it 'raises an error with missing data' do
        get :update, params: { id: classroom1.id, classroom: { name: nil }, format: :json }
        expect(response).to have_http_status(422)
        expect(response.body).to include('error')
      end
    end
  end

  describe '#new' do
    it 'returns blank classroom' do
      get :new, format: :json
      expect(response).to have_http_status(200)
    end
  end

  describe '#create' do
    context 'success' do
      it 'saves a new classroom' do
        get :create, params: { classroom: { name: 'Test Classroom 1' }, format: :json }
        expect(response).to have_http_status(200)
        expect(Classroom.find_by_name('Test Classroom 1')).to be_instance_of(Classroom)
      end
    end

    context 'failure' do
      it 'raises an error with missing data' do
        get :create, params: { classroom: { name: nil }, format: :json }
        expect(response).to have_http_status(422)
        expect(response.body).to include('error')
      end
    end
  end

  describe '#delete' do
    context 'success' do
      it 'deletes selected classroom' do
        get :delete, params: { id: classroom1.id, format: :json }
        expect(response).to have_http_status(200)
        expect(Classroom.all).not_to include(classroom1)
      end
    end

    context 'failure' do
      it 'restricts classroom belonging to other teacher' do
        get :delete, params: { id: classroom2.id, format: :json }
        expect(response).to have_http_status(401)
      end
    end
  end
end
