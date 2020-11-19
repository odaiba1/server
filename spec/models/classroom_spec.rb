# == Schema Information
#
# Table name: classrooms
#
#  id         :bigint           not null, primary key
#  end_time   :datetime
#  grade      :integer
#  group      :string
#  start_time :datetime
#  subject    :string
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
      subject: 'English',
      group: 'A',
      grade: 1,
      user: teacher
    )
  end

  context 'valid' do
    it 'with valid attributes' do
      expect(subject).to be_valid
    end
  end

  context 'not valid' do
    it 'without a subject' do
      subject.subject = nil
      expect(subject).not_to be_valid
    end

    it 'without a grade' do
      subject.grade = nil
      expect(subject).not_to be_valid
    end

    it 'without a group' do
      subject.group = nil
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

    it 'start time in the past' do
      subject.start_time = Time.now - 1.hour
      expect(subject).not_to be_valid
    end
  end

  context 'methods' do
    describe '.class_time' do
      it 'returns the correct time output with a time range' do
        subject.start_time = Time.zone.local(2020, 12, 12, 9, 0)
        subject.end_time = Time.zone.local(2020, 12, 12, 10, 15)
        expect(subject.class_time).to eql('09:00 - 10:15')
      end

      it 'returns message without range' do
        expect(subject.class_time).to eql('Time range not set')
      end
    end

    describe '.name' do
      it 'returns the correct name for display' do
        expect(subject.name).to eql('Grade 1 English Class A')
      end
    end

    describe '.minified_url_for_teacher' do
      context 'test and staging env' do
        it 'returns full url' do
          expect(subject.minified_url_for_teacher).to include(
            "http://localhost:3000/classrooms/#{subject.id}?email=#{teacher.email}&password="
          )
        end
      end

      context 'production env' do
        let(:link_shortener) { double(LinkShortener) }

        before do
          allow(Rails).to receive(:env).and_return('production')
          allow(LinkShortener).to receive(:new).and_return(link_shortener)
          allow(link_shortener).to receive(:call).and_return('www.test.com')
        end

        it 'returns minified url' do
          expect(subject.minified_url_for_teacher).to eql('www.test.com')
        end
      end
    end
  end
end
