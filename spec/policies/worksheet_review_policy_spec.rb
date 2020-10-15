require 'rails_helper'

RSpec.describe WorksheetReviewPolicy do
  subject { WorksheetReviewPolicy.new(user, worksheet_review) }
  let(:worksheet_review) { build(:worksheet_review) }

  context 'admin user' do
    let(:user) { create(:admin) }

    it { should permit(:create) }
  end

  context 'teacher user' do
    let(:worksheet_review) { build(:worksheet_review) }
    let(:user) { worksheet_review.teacher }

    context 'own worksheet review' do
      it { should permit(:create) }

    end

    context 'foreign worksheet review' do
      let(:user) {create(:teacher)}

      it { should_not permit(:create) }
    end
  end

  context 'student user' do
    let(:user) { create(:student) }

    it { should_not permit(:create) }
  end

  # context 'policy scope' do
  #   subject { Pundit.policy_scope!(user, WorksheetReview) }

  #   before do
  #     create(:worksheet_review)
  #     create(:worksheet_review)
  #   end

  #   context 'admin' do
  #     let(:user) { create(:admin) }
  #     it { expect(subject.size).to eq(2) }
  #   end

  #   context 'teacher' do
  #     let(:user) { User.where(role: 'teacher').first }
  #     it { expect(subject.size).to eq(1) }
  #     it { expect(subject.first.user_id).to eq(user.id) }
  #   end

  #   context 'student' do
  #     let(:user) { create(:student) }
  #     it { expect(subject.size).to eq(0) }
  #   end
  # end
end
