# == Schema Information
#
# Table name: student_classrooms
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  classroom_id :bigint           not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_student_classrooms_on_classroom_id  (classroom_id)
#  index_student_classrooms_on_user_id       (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (classroom_id => classrooms.id)
#  fk_rails_...  (user_id => users.id)
#
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
