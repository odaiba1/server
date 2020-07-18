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
    it { should permit(:delete) }
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
      it { should permit(:delete) }
    end

    context 'foreign classroom' do
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
    let(:classroom) { create(:classroom) }

    context 'own classroom' do
      let!(:student_classroom) { build(:student_classroom, classroom: classroom, user: user) }
      it { should permit(:index) }
      it { should permit(:show) }
      it { should_not permit(:new) }
      it { should_not permit(:create) }
      it { should_not permit(:edit) }
      it { should_not permit(:update) }
      it { should_not permit(:delete) }
    end

    context 'foreign classroom' do
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
