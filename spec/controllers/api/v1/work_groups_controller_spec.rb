require 'rails_helper'

RSpec.describe Api::V1::WorkGroupsController, type: :controller do
  let(:teacher)     { create(:teacher) }
  let(:classroom)   { create(:classroom, user: teacher) }
  let(:work_group1) { create(:work_group, classroom: classroom) }
  let(:work_group2) { create(:work_group, aasm_state: 'created') }
  let(:work_group3) { create(:work_group, aasm_state: 'done') }

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
        expect(JSON.parse(response.body)['all_work_groups'].size).to eq(1)
      end
    end

    context 'failure' do
      it 'restricts work groups belonging to other teacher' do
        get :index, format: :json, params: { classroom_id: work_group2.classroom.id }
        expect(response).to have_http_status(403)
      end
    end
  end

  describe '#show' do
    context 'success' do
      it 'returns selected work group' do
        get :show, params: { id: work_group1.id, format: :json }
        expect(response).to have_http_status(200)
        expect(controller.instance_variable_get(:@work_group).id).to eq(work_group1.id)
      end
    end

    context 'failure' do
      it 'returns 404 for missing work group' do
        get :show, params: { id: 999, format: :json }
        expect(response).to have_http_status(404)
      end

      it 'restricts work group belonging to other teacher' do
        get :show, params: { id: work_group2.id, format: :json }
        expect(response).to have_http_status(403)
      end
    end
  end

  describe '#edit' do
    context 'success' do
      it 'returns selected work group to modify' do
        get :edit, params: { id: work_group1.id, format: :json }
        expect(response).to have_http_status(200)
        expect(controller.instance_variable_get(:@work_group).id).to eq(work_group1.id)
      end
    end

    context 'failure' do
      it 'returns 404 for missing work group' do
        get :edit, params: { id: 999, format: :json }
        expect(response).to have_http_status(404)
      end

      it 'restricts work group belonging to other teacher' do
        get :edit, params: { id: work_group2.id, format: :json }
        expect(response).to have_http_status(403)
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
        expect(controller.instance_variable_get(:@work_group).name).to eq('New Test work_group')
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
        expect(response).to have_http_status(403)
      end

      it 'raises an error with missing data' do
        patch :update, params: {
          id: work_group1.id,
          work_group: { video_call_code: nil },
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
        expect(response).to have_http_status(403)
      end
    end
  end

  describe '#create' do
    context 'success' do
      it 'saves a new work_group' do
        put :create, params: {
          classroom_id: classroom.id,
          work_group: {
            name: 'Test work group 1',
            video_call_code: 'abc',
            session_time: 1_200_000,
            turn_time: 3000,
            start_at: DateTime.now + 1.hour
          },
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
          work_group: { video_call_code: nil },
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
        expect(response).to have_http_status(403)
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
        expect(response).to have_http_status(403)
      end

      it 'returns 404 for missing classroom' do
        delete :destroy, params: { id: 999, format: :json }
        expect(response).to have_http_status(404)
      end
    end
  end

  describe '#initiate' do
    context 'success' do
      it 'sets the progess status of a work group to in_progress' do
        patch :initiate, params: { id: work_group2.id, format: :json }
        expect(JSON.parse(response.body)['aasm_state']).to eq('in_progress')
        expect(response).to have_http_status(200)
      end
    end

    context 'failure' do
      it 'returns 204 for work group already in_progress' do
        patch :initiate, params: { id: work_group1.id, format: :json }
        expect(response).to have_http_status(204)
      end

      it 'returns 204 for work group already done' do
        patch :initiate, params: { id: work_group3.id, format: :json }
        expect(response).to have_http_status(204)
      end

      it 'returns 404 for nonexistent work group' do
        patch :initiate, params: { id: 4, format: :json }
        expect(JSON.parse(response.body)['error']).to eq("Couldn't find WorkGroup with 'id'=4")
        expect(response).to have_http_status(404)
      end
    end
  end

  describe '#conclude' do
    context 'success' do
      it 'sets the progess status of a work group to done' do
        patch :conclude, params: { id: work_group1.id, format: :json }
        expect(JSON.parse(response.body)['aasm_state']).to eq('done')
        expect(response).to have_http_status(200)
      end
    end

    context 'failure' do
      it 'returns 204 for work group just created' do
        patch :conclude, params: { id: work_group2.id, format: :json }
        expect(response).to have_http_status(204)
      end

      it 'returns 204 for work group already done' do
        patch :conclude, params: { id: work_group3.id, format: :json }
        expect(response).to have_http_status(204)
      end

      it 'returns 404 for nonexistent work groups' do
        patch :conclude, params: { id: 4, format: :json }
        expect(JSON.parse(response.body)['error']).to eq("Couldn't find WorkGroup with 'id'=4")
        expect(response).to have_http_status(404)
      end
    end
  end

  describe '#cancel' do
    context 'success' do
      it 'sets state of in progress work group to canceled' do
        patch :cancel, params: { id: work_group1.id, format: :json }
        expect(JSON.parse(response.body)['aasm_state']).to eq('canceled')
        expect(response).to have_http_status(200)
      end

      it 'sets state of created work group to canceled' do
        patch :cancel, params: { id: work_group2.id, format: :json }
        expect(JSON.parse(response.body)['aasm_state']).to eq('canceled')
        expect(response).to have_http_status(200)
      end
    end

    context 'failure' do
      it 'returns 404 for nonexistent work group' do
        patch :cancel, params: { id: 4, format: :json }
        expect(JSON.parse(response.body)['error']).to eq("Couldn't find WorkGroup with 'id'=4")
        expect(response).to have_http_status(404)
      end

      it 'sets state of work group that is done' do
        expect { patch :cancel, params: { id: work_group3.id, format: :json } }.to raise_error(AASM::InvalidTransition)
      end
    end
  end
end
