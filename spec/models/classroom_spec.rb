require 'rails_helper'

RSpec.describe Classroom, type: :model do
  let(:teacher) { create(:teacher) }
  subject do
    described_class.new(name: 'Test Classroom', user: teacher)
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without a name' do
    subject.name = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without a user' do
    subject.user = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid with a student' do
    subject.user = create(:student)
    expect(subject).not_to be_valid
  end
end
