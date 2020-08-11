require 'rails_helper'

RSpec.describe WorksheetPolicy do
  subject { WorksheetPolicy.new(user, worksheet) }
  let(:worksheet) { build(:worksheet) }

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

    context 'own worksheet' do
      let(:worksheet_template) { create(:worksheet_template, user: user) }
      let(:worksheet)          { build(:worksheet, worksheet_template: worksheet_template) }
      it { should permit(:index) }
      it { should permit(:show) }
      it { should permit(:new) }
      it { should permit(:create) }
      it { should permit(:edit) }
      it { should permit(:update) }
      it { should_not permit(:destroy) }
    end

    context 'foreign worksheet' do
      it { should_not permit(:index) }
      it { should_not permit(:show) }
      it { should_not permit(:new) }
      it { should_not permit(:create) }
      it { should_not permit(:edit) }
      it { should_not permit(:update) }
      it { should_not permit(:destroy) }
    end
  end

  context 'student user' do
    let(:user)               { create(:student) }
    let(:work_group)         { create(:work_group) }
    let(:student_work_group) { create(:student_work_group, user: user, work_group: work_group) }

    context 'own worksheet' do
      let(:worksheet) { build(:worksheet, work_group: work_group) }
      it { should permit(:index) }
      it { should permit(:show) }
      it { should_not permit(:new) }
      it { should_not permit(:create) }
      it { should permit(:edit) }
      it { should permit(:update) }
      it { should_not permit(:destroy) }
    end

    context 'foreign worksheet' do
      it { should_not permit(:index) }
      it { should_not permit(:show) }
      it { should_not permit(:new) }
      it { should_not permit(:create) }
      it { should_not permit(:edit) }
      it { should_not permit(:update) }
      it { should_not permit(:destroy) }
    end
  end
end
