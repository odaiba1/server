require 'rails_helper'

RSpec.describe Api::V1::WorkGroupsController, type: :controller do
  let(:teacher)     { create(:teacher) }
  let(:classroom)   { create(:classroom, user: teacher) }
  let(:work_group1) { create(:work_group, classroom: classroom) }
  let(:work_group2) { create(:work_group) }

  before do
    request.headers['X-User-Email'] = teacher.email
    request.headers['X-User-Token'] = teacher.authentication_token
  end

  describe '#index' do
    context 'success' do
      it 'lists work groups belonging to teacher' do
        work_group1
        work_group2
        get :index, format: :json, params: { classroom_id: classroom.id }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).size).to eq(1)
      end
    end

    context 'failure' do
      it 'restricts work groups belonging to other teacher' do
        get :index, format: :json, params: { classroom_id: work_group2.classroom.id }
        expect(response).to have_http_status(401)
      end
    end
  end

  describe '#show' do
    context 'success' do
      it 'returns selected work group' do
        get :show, params: { id: work_group1.id, format: :json }
        expect(response).to have_http_status(200)
        expect(response.body).to eq(work_group1.to_json)
      end
    end

    context 'failure' do
      it 'returns 404 for missing work group' do
        get :show, params: { id: 999, format: :json }
        expect(response).to have_http_status(404)
      end

      it 'restricts work group belonging to other teacher' do
        get :show, params: { id: work_group2.id, format: :json }
        expect(response).to have_http_status(401)
      end
    end
  end

  describe '#edit' do
    context 'success' do
      it 'returns selected work group to modify' do
        get :edit, params: { id: work_group1.id, format: :json }
        expect(response).to have_http_status(200)
        expect(response.body).to eq(work_group1.to_json)
      end
    end

    context 'failure' do
      it 'returns 404 for missing work group' do
        get :edit, params: { id: 999, format: :json }
        expect(response).to have_http_status(404)
      end

      it 'restricts work group belonging to other teacher' do
        get :edit, params: { id: work_group2.id, format: :json }
        expect(response).to have_http_status(401)
      end
    end
  end

  describe '#update' do
    context 'success' do
      it 'changes selected work group' do
        patch :update, params: {
          id: work_group1.id,
          work_group: { name: 'New Test work_group' },
          format: :json
        }
        expect(response).to have_http_status(200)
        expect(response.body).to include('New Test')
      end
    end

    context 'failure' do
      it 'returns 404 for missing work group' do
        patch :update, params: {
          id: 999,
          work_group: { name: 'New Test work_group' },
          format: :json
        }
        expect(response).to have_http_status(404)
      end

      it 'restricts work group belonging to other teacher' do
        patch :update, params: {
          id: work_group2.id,
          work_group: { name: 'New Test work_group' },
          format: :json
        }
        expect(response).to have_http_status(401)
      end

      it 'raises an error with missing data' do
        patch :update, params: {
          id: work_group1.id,
          work_group: { name: nil },
          format: :json
        }
        expect(response).to have_http_status(422)
        expect(response.body).to include('error')
      end
    end
  end

  describe '#new' do
    context 'success' do
      it 'returns blank work group' do
        get :new, format: :json, params: { classroom_id: classroom.id }
        expect(response).to have_http_status(200)
        expect(response.body).to eq(WorkGroup.new.to_json)
      end
    end

    context 'failure' do
      it 'restricts creating a work group to a classroom belonging to other teacher' do
        get :new, format: :json, params: { classroom_id: work_group2.classroom.id }
        expect(response).to have_http_status(401)
      end
    end
  end

  describe '#create' do
    context 'success' do
      it 'saves a new work_group' do
        put :create, params: {
          classroom_id: classroom.id,
          work_group: { name: 'Test work group 1' },
          format: :json
        }
        expect(response).to have_http_status(200)
        expect(WorkGroup.find_by_name('Test work group 1')).to be_instance_of(WorkGroup)
      end
    end

    context 'failure' do
      it 'raises an error with missing data' do
        put :create, params: {
          classroom_id: classroom.id,
          work_group: { name: nil },
          format: :json
        }
        expect(response).to have_http_status(422)
        expect(response.body).to include('error')
      end

      it 'restricts creating a work group to a classroom belonging to other teacher' do
        put :create, params: {
          classroom_id: work_group2.classroom.id,
          work_group: { name: 'Test work group 2' },
          format: :json
        }
        expect(response).to have_http_status(401)
      end
    end
  end

  describe '#destroy' do
    context 'success' do
      it 'deletes selected work_group' do
        delete :destroy, params: { id: work_group1.id, format: :json }
        expect(response).to have_http_status(200)
        expect(WorkGroup.all).not_to include(work_group1)
      end
    end

    context 'failure' do
      it 'restricts work_group belonging to other teacher' do
        delete :destroy, params: { id: work_group2.id, format: :json }
        expect(response).to have_http_status(401)
      end

      it 'returns 404 for missing classroom' do
        delete :destroy, params: { id: 999, format: :json }
        expect(response).to have_http_status(404)
      end
    end
  end
end
