require 'rails_helper'

RSpec.describe WorksheetsController, type: :controller do
  let(:teacher1)   { FactoryBot.create(:teacher) }
  let(:teacher2)   { FactoryBot.create(:teacher) }
  let(:worksheet1) { FactoryBot.create(:worksheet, user: teacher1) }
  let(:worksheet2) { FactoryBot.create(:worksheet, user: teacher2) }

  before do
    sign_in teacher1
  end

  describe '#index' do

  end

  describe '#show' do
    it 'returns selected worksheet' do
      get :show, params: { id: worksheet1.id, format: :json }
      expect(response).to have_http_status(200)
      expect(response.body).to eq(worksheet1.to_json)
    end
  end

  describe '#edit' do

  end

  describe '#update' do

  end

  describe '#create' do

  end

  describe '#new' do

  end

  describe '#delete' do

  end
end
