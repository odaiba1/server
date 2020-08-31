require 'rails_helper'

RSpec.describe WorkGroupPolicy do
  subject { WorkGroupPolicy.new(user, work_group) }
  let(:work_group) { build(:work_group) }

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

    context 'own work group' do
      let(:classroom)  { create(:classroom, user: user) }
      let(:work_group) { build(:work_group, classroom: classroom) }
      it { should permit(:index) }
      it { should permit(:show) }
      it { should permit(:new) }
      it { should permit(:create) }
      it { should permit(:edit) }
      it { should permit(:update) }
      it { should permit(:destroy) }
    end

    context 'foreign work group' do
      it { should_not permit(:index) }
      it { should_not permit(:show) }
      it { should_not permit(:edit) }
      it { should_not permit(:update) }
      it { should_not permit(:destroy) }
    end
  end

  context 'student user' do
    let(:user) { create(:student) }

    context 'own work group' do
      let(:work_group)          { create(:work_group) }
      let!(:student_work_group) { create(:student_work_group, user: user, work_group: work_group) }
      it { should permit(:index) }
      it { should permit(:show) }
      it { should_not permit(:new) }
      it { should_not permit(:create) }
      it { should_not permit(:edit) }
      it { should_not permit(:update) }
      it { should_not permit(:destroy) }
    end

    context 'foreign work group' do
      it { should_not permit(:index) }
      it { should_not permit(:show) }
      it { should_not permit(:edit) }
      it { should_not permit(:update) }
      it { should_not permit(:destroy) }
    end
  end

  context 'policy scope' do
    subject { Pundit.policy_scope!(user, WorkGroup) }

    before do
      create(:work_group)
      create(:work_group)
    end

    context 'admin' do
      let(:user) { create(:admin) }
      it { expect(subject.size).to eq(2) }
    end

    context 'teacher' do
      let(:user) { User.where(role: 'teacher').first }
      it { expect(subject.size).to eq(1) }
      it { expect(user.classrooms.ids).to include(subject.first.classroom_id) }
    end

    context 'student' do
      let(:user) { create(:student_work_group, work_group: WorkGroup.first).user }
      it { expect(subject.size).to eq(1) }
      it { expect(user.work_groups.ids).to include(subject.first.id) }
    end
  end
end
