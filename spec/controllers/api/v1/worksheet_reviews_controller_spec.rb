require 'rails_helper'

RSpec.describe Api::V1::WorksheetReviewsController, type: :controller do
  let(:teacher)             { create(:teacher) }
  let(:student)             { create(:student) }

  let(:classroom)   { create(:classroom, user: teacher) }
  let(:work_group) { create(:work_group, classroom: classroom) }
  let(:worksheet_template)  { create(:worksheet_template, user: teacher) }
  let(:worksheet)          { create(:worksheet, work_group: work_group, worksheet_template: worksheet_template) }
  let(:worksheet_review) { create(:worksheet_review, user: student, worksheet: worksheet) }

  before do
    request.headers['X-User-Email'] = teacher.email
    request.headers['X-User-Token'] = teacher.authentication_token
  end

  describe '#create' do
    context 'success' do
      it 'saves a new worksheet review' do
        put :create, params: {
          worksheet_id: worksheet.id,
          worksheet_review: {
            content: 'Test Worksheet Review',
            user_id: student.id,
            worksheet_id: worksheet.id
          },
          format: :json }
        expect(response).to have_http_status(200)
        expect(WorksheetReview.find_by_content('Test Worksheet Review')).to be_instance_of(WorksheetReview)
      end
    end

    context 'failure' do
      it 'raises an error with missing data' do
        put :create, params: {
          worksheet_id: worksheet.id,
          worksheet_review: {
            content: nil
          },
          format: :json }
        expect(response).to have_http_status(422)
        expect(response.body).to include('error')
      end
    end
  end
end
