require 'rails_helper'

RSpec.describe WorksheetsController, type: :controller do
  let(:teacher) { FactoryBot.create(:teacher) }

  before do
    sign_in teacher
  end

  describe '#show' do
    it 'returns selected worksheet' do
      get :show, params: {
        # classroom_id: Classroom.first.id,
        # workgroup_id: WorkGroup.first.id,
        id: Worksheet.first.id,
        format: :json
      }
      expect(response).to have_http_status(200)
      expect(response.body).to eq(Worksheet.first.to_json)
    end
  end
end
