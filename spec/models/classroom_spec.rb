# == Schema Information
#
# Table name: classrooms
#
#  id         :bigint           not null, primary key
#  end_time   :datetime
#  name       :string
#  start_time :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_classrooms_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Classroom, type: :model do
  it 'has a valid factory' do
    expect(build(:classroom)).to be_valid
  end

  let(:teacher) { create(:teacher) }
  subject do
    described_class.new(
      name: 'Test Classroom',
      user: teacher,
      start_time: Time.new(2021, 10, 18, 9, 0, 0, '+00:00'),
      end_time: Time.new(2021, 10, 18, 10, 15, 0, '+00:00')
    )
  end

  context 'valid' do
    it 'with valid attributes' do
      expect(subject).to be_valid
    end
  end

  context 'not valid' do
    it 'without a name' do
      subject.name = nil
      expect(subject).not_to be_valid
    end

    it 'without a user' do
      subject.user = nil
      expect(subject).not_to be_valid
    end

    it 'with a student' do
      subject.user = create(:student)
      expect(subject).not_to be_valid
    end

    it 'has end time earlier than start time' do
      subject.start_time = Time.now + 1.hour
      subject.end_time = Time.now
      expect(subject).not_to be_valid
    end

    it 'without a start time' do
      subject.start_time = nil
      expect(subject).not_to be_valid
    end

    it 'without an end time' do
      subject.end_time = nil
      expect(subject).not_to be_valid
    end

    it 'without start and end time' do
      subject.end_time = nil
      subject.start_time = nil
      expect(subject).not_to be_valid
    end

    it 'start time in the past' do
      subject.start_time = Time.now - 1.hour
      expect(subject).not_to be_valid
    end
  end

  context 'valid method' do
    it 'returns the correct time output' do
      expect(subject.class_time).to eql('09:00 - 10:15')
    end
  end
end
