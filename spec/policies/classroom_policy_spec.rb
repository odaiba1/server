require 'rails_helper'

RSpec.describe ClassroomPolicy do
  subject { ClassroomPolicy.new(user, classroom) }
  let(:classroom) { build(:classroom) }

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

    context 'own classroom' do
      let(:classroom) { build(:classroom, user: user) }
      it { should permit(:index) }
      it { should permit(:show) }
      it { should permit(:new) }
      it { should permit(:create) }
      it { should permit(:edit) }
      it { should permit(:update) }
      it { should permit(:destroy) }
    end

    context 'foreign classroom' do
      it { should_not permit(:index) }
      it { should_not permit(:show) }
      it { should_not permit(:edit) }
      it { should_not permit(:update) }
      it { should_not permit(:destroy) }
    end
  end

  context 'student user' do
    let(:user) { create(:student) }
    let(:classroom) { create(:classroom) }

    context 'own classroom' do
      let!(:student_classroom) { create(:student_classroom, classroom: classroom, user: user) }
      it { should permit(:index) }
      it { should permit(:show) }
      it { should_not permit(:new) }
      it { should_not permit(:create) }
      it { should_not permit(:edit) }
      it { should_not permit(:update) }
      it { should_not permit(:destroy) }
    end

    context 'foreign classroom' do
      it { should_not permit(:index) }
      it { should_not permit(:show) }
      it { should_not permit(:edit) }
      it { should_not permit(:update) }
      it { should_not permit(:destroy) }
    end
  end

  context 'policy scope' do
    subject { Pundit.policy_scope!(user, Classroom) }

    before do
      create(:classroom)
      create(:classroom)
    end

    context 'admin' do
      let(:user) { create(:admin) }
      it { expect(subject.size).to eq(2) }
    end

    context 'teacher' do
      let(:user) { Classroom.first.teacher }
      it { expect(subject.size).to eq(1) }
      it { expect(subject.first.user_id).to eq(user.id) }
    end

    context 'student' do
      let(:user) { create(:student_classroom, classroom: Classroom.first).user }
      it { expect(subject.size).to eq(1) }
      it { expect(user.attending_classrooms.ids).to include(subject.first.id) }
    end
  end
end
