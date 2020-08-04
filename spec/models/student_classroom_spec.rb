require 'rails_helper'

RSpec.describe StudentClassroom, type: :model do
  let(:student)   { create(:student) }
  let(:classroom) { create(:classroom) }
  subject do
    described_class.new(classroom: classroom, user: student)
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without a user' do
    subject.user = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without a classroom' do
    subject.classroom = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid with a teacher' do
    subject.user = create(:teacher)
    expect(subject).not_to be_valid
  end
end
