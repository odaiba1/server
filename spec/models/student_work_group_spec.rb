require 'rails_helper'

RSpec.describe StudentWorkGroup, type: :model do
  let(:student)    { create(:student) }
  let(:work_group) { create(:work_group) }
  subject do
    described_class.new(work_group: work_group, user: student)
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without a user' do
    subject.user = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without a work group' do
    subject.work_group = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid with a teacher' do
    subject.user = create(:teacher)
    expect(subject).not_to be_valid
  end
end
