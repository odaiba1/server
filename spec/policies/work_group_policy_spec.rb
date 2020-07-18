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
    it { should permit(:delete) }
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
      it { should permit(:delete) }
    end

    context 'foreign work group' do
      it { should_not permit(:index) }
      it { should_not permit(:show) }
      it { should_not permit(:new) }
      it { should_not permit(:create) }
      it { should_not permit(:edit) }
      it { should_not permit(:update) }
      it { should_not permit(:delete) }
    end
  end

  context 'student user' do
    let(:user) { create(:student) }

    context 'own work group' do
      let(:classroom)         { create(:classroom, user: user) }
      let(:student_classroom) { create(:student_classroom, classroom: classroom, user: user) }
      let(:work_group)        { build(:work_group, classroom: classroom) }
      it { should_not permit(:index) }
      it { should permit(:show) }
      it { should_not permit(:new) }
      it { should_not permit(:create) }
      it { should_not permit(:edit) }
      it { should_not permit(:update) }
      it { should_not permit(:delete) }
    end

    context 'foreign work group' do
      it { should_not permit(:index) }
      it { should_not permit(:show) }
      it { should_not permit(:new) }
      it { should_not permit(:create) }
      it { should_not permit(:edit) }
      it { should_not permit(:update) }
      it { should_not permit(:delete) }
    end
  end
end
