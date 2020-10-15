require 'rails_helper'

RSpec.describe Api::V1::WorksheetReviewsController, type: :controller do
  let(:teacher)              { create(:teacher) }
  let(:teacher2)             { create(:teacher) }
  let(:student)              { create(:student) }

  let(:classroom)            { create(:classroom, user: teacher) }
  let(:classroom2)           { create(:classroom, user: teacher2) }
  let(:work_group)           { create(:work_group, classroom: classroom) }
  let(:work_group2)          { create(:work_group, classroom: classroom2) }
  let(:worksheet_template)   { create(:worksheet_template, user: teacher) }
  let(:worksheet_template2)  { create(:worksheet_template, user: teacher2) }
  let(:worksheet)            { create(:worksheet, work_group: work_group, worksheet_template: worksheet_template) }
  let(:worksheet2)           { create(:worksheet, work_group: work_group2, worksheet_template: worksheet_template2) }
  let(:worksheet_review)     { create(:worksheet_review, user: student, worksheet: worksheet) }
  let(:worksheet_review2)    { create(:worksheet_review, user: student, worksheet: worksheet2) }


  before do
    request.headers['X-User-Email'] = teacher.email
    request.headers['X-User-Token'] = teacher.authentication_token
  end

  describe '#create' do
    context 'success' do
      it 'saves a new worksheet review' do
        post :create, params: {
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
        post :create, params: {
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

  describe '#update' do
    context 'success' do
      it 'updates a worksheet review' do
        patch :update, params: {
          id: worksheet_review.id,
          worksheet_review: {
            content: 'Test Worksheet Review Should Be Updated'
          },
          format: :json }
        expect(response).to have_http_status(200)
        expect(WorksheetReview.find_by_content('Test Worksheet Review Should Be Updated')).to be_instance_of(WorksheetReview)
      end
    end

    context 'failure' do
      it 'returns 404 for missing worksheet review' do
        patch :update, params: {
          id: 999,
          worksheet_review: { content: 'Test Worksheet Review Should Not Be Updated' },
          format: :json
        }
        expect(response).to have_http_status(404)
      end

      it 'restricts worksheet review belonging to another teacher' do
        patch :update, params: {
          id: worksheet_review2.id,
          worksheet_review: { content: 'Test Worksheet Review Should Not Be Updated' },
          format: :json
        }
        expect(response).to have_http_status(403)
      end

      it 'raises an error with missing data' do
        patch :update, params: {
          id: worksheet_review.id,
          worksheet_review: { content: nil },
          format: :json
        }
        expect(response).to have_http_status(422)
        expect(response.body).to include('error')
      end
    end
  end

  describe '#destroy' do
    context 'success' do
      it 'deletes selected worksheet review' do
        delete :destroy, params: { id: worksheet_review.id, format: :json }
        expect(response).to have_http_status(200)
        expect(WorksheetReview.all).not_to include(worksheet_review)
      end
    end

    context 'failure' do
      it 'restricts worksheet review belonging to another teacher' do
        delete :destroy, params: { id: worksheet_review2.id, format: :json }
        expect(response).to have_http_status(403)
      end

      it 'returns 404 for missing worksheet_review' do
        delete :destroy, params: { id: 999, format: :json }
        expect(response).to have_http_status(404)
      end
    end
  end
end
