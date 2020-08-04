require 'rails_helper'

RSpec.describe StudentClassroom, type: :model do
  let(:student)   { create(:student) }
  let(:classroom) { create(:classroom) }
  subject do
    described_class.new(classroom: classroom, user: student)
  end

  context 'valid' do
    it 'with valid attributes' do
      expect(subject).to be_valid
    end
  end

  context 'not valid' do
    it 'without a user' do
      subject.user = nil
      expect(subject).not_to be_valid
    end

    it 'without a classroom' do
      subject.classroom = nil
      expect(subject).not_to be_valid
    end

    it 'with a teacher' do
      subject.user = create(:teacher)
      expect(subject).not_to be_valid
    end
  end
end
