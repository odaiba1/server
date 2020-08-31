require 'rails_helper'

RSpec.describe WorksheetTemplatePolicy do
  subject { WorksheetTemplatePolicy.new(user, worksheet_template) }
  let(:worksheet_template) { build(:worksheet_template) }

  context 'admin user' do
    let(:user) { create(:admin) }
    it { should permit(:index) }
    it { should permit(:show) }
    it { should permit(:new) }
    it { should permit(:create) }
    it { should permit(:edit) }
    it { should permit(:update) }
    it { should permit(:destroy) }
  end

  context 'teacher user' do
    let(:user) { create(:teacher) }

    context 'own worksheet template' do
      let(:worksheet_template) { build(:worksheet_template, user: user) }
      it { should permit(:index) }
      it { should permit(:show) }
      it { should permit(:new) }
      it { should permit(:create) }
      it { should permit(:edit) }
      it { should permit(:update) }
      it { should permit(:destroy) }
    end

    context 'foreign worksheet template' do
      it { should_not permit(:index) }
      it { should_not permit(:show) }
      it { should_not permit(:edit) }
      it { should_not permit(:update) }
      it { should_not permit(:destroy) }
    end
  end

  context 'student user' do
    let(:user) { create(:student) }

    it { should_not permit(:index) }
    it { should_not permit(:show) }
    it { should_not permit(:new) }
    it { should_not permit(:create) }
    it { should_not permit(:edit) }
    it { should_not permit(:update) }
    it { should_not permit(:destroy) }
  end

  context 'policy scope' do
    subject { Pundit.policy_scope!(user, WorksheetTemplate) }

    before do
      create(:worksheet_template)
      create(:worksheet_template)
    end

    context 'admin' do
      let(:user) { create(:admin) }
      it { expect(subject.size).to eq(2) }
    end

    context 'teacher' do
      let(:user) { User.where(role: 'teacher').first }
      it { expect(subject.size).to eq(1) }
      it { expect(subject.first.user_id).to eq(user.id) }
    end

    context 'student' do
      let(:user) { create(:student) }
      it { expect(subject.size).to eq(0) }
    end
  end
end
