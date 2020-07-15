require 'rails_helper'

RSpec.describe WorksheetsController, type: :controller do
  let(:teacher) { FactoryBot.create(:teacher) }

  before do
    sign_in teacher
  end

  describe '#show' do
    it 'returns selected worksheet' do
      get :show, params: { id: Worksheet.first.id }
      expect(response).to have_http_status(200)
      expect(response.body).to eq(Worksheet.first.to_json)
    end
  end
end
