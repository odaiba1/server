require 'rails_helper'

RSpec.describe WorksheetReviewPolicy do
  subject { WorksheetReviewPolicy.new(user, worksheet_review) }
  let(:worksheet_review) { build(:worksheet_review) }

  context 'admin user' do
    let(:user) { create(:admin) }

    it { should permit(:create) }
    it { should permit(:update) }
    it { should permit(:destroy) }
  end

  context 'teacher user' do
    let(:worksheet_review) { build(:worksheet_review) }
    let(:user) { worksheet_review.teacher }

    context 'own worksheet review' do
      it { should permit(:create) }
      it { should permit(:update) }
      it { should permit(:destroy) }

    end

    context 'foreign worksheet review' do
      let(:user) {create(:teacher)}

      it { should_not permit(:create) }
      it { should_not permit(:update) }
      it { should_not permit(:destroy) }
    end
  end

  context 'student user' do
    let(:user) { create(:student) }

    it { should_not permit(:create) }
    it { should_not permit(:update) }
    it { should_not permit(:destroy) }
  end
end
