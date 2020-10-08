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
    end

    context 'foreign worksheet' do
      it { should_not permit(:index) }
      it { should_not permit(:show) }
      it { should_not permit(:edit) }
      it { should_not permit(:update) }
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
    end

    context 'foreign worksheet' do
      it { should_not permit(:index) }
      it { should_not permit(:show) }
      it { should_not permit(:edit) }
      it { should_not permit(:update) }
    end
  end

  context 'policy scope' do
    subject { Pundit.policy_scope!(user, Worksheet) }

    before do
      create(:worksheet)
      create(:worksheet)
    end

    context 'admin' do
      let(:user) { create(:admin) }
      it { expect(subject.size).to eq(2) }
    end

    context 'teacher' do
      let(:user) { User.where(role: 'teacher').first }
      it { expect(subject.size).to eq(1) }
      it { expect(user.worksheet_templates.ids).to include(subject.first.worksheet_template_id) }
    end

    context 'student' do
      let(:user) { create(:student_work_group, work_group: Worksheet.first.work_group).user }
      it { expect(subject.size).to eq(1) }
      it { expect(user.work_groups.ids).to include(subject.first.work_group_id) }
    end
  end
end
