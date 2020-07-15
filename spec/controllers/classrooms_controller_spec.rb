require 'rails_helper'

RSpec.describe ClassroomsController, type: :controller do
  @user = User.find_by_role('teacher')

  before do
    sign_in @user
  end

  describe '#index' do
    it 'returns all classrooms' do
      get :index
      expect(response).to have_http_status(200)
      expect(response.body).to include('4B English')
    end
  end
end
