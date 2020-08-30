# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  authentication_token   :string(30)
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default("student")
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_authentication_token  (authentication_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  subject do
    described_class.new(
      name: 'Test User',
      email: 'test@mail.com',
      password: 'Password',
      role: (0..2).to_a.sample
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

    it 'without an email' do
      subject.email = nil
      expect(subject).not_to be_valid
    end

    it 'without a password' do
      subject.password = nil
      expect(subject).not_to be_valid
    end

    it 'without a role' do
      subject.role = nil
      expect(subject).not_to be_valid
    end
  end

  context 'relations' do
    let(:teacher)               { create(:teacher) }
    let(:classroom1)            { create(:classroom, user: teacher) }
    let(:classroom2)            { create(:classroom) }
    let(:classroom3)            { create(:classroom, user: teacher) }
    let(:student_a)             { create(:student) }
    let(:student_b)             { create(:student) }
    let!(:student_a_classroom1) { create(:student_classroom, user: student_a, classroom: classroom1) }
    let!(:student_b_classroom1) { create(:student_classroom, user: student_b, classroom: classroom1) }
    let!(:student_a_classroom2) { create(:student_classroom, user: student_a, classroom: classroom2) }

    it 'returns students of a teacher' do
      expect(teacher.students).to include(student_a)
      expect(teacher.students).to include(student_b)
      expect(teacher.students.size).to eq(2)
    end

    it 'return teachers of a student' do
      teacher2 = classroom2.teacher
      expect(student_a.teachers).to include(teacher)
      expect(student_a.teachers).to include(teacher2)
      expect(student_a.teachers.size).to eq(2)
    end

    it 'returns teacher classroom' do
      classroom3
      expect(teacher.classrooms).to include(classroom1)
      expect(teacher.classrooms).to include(classroom3)
      expect(teacher.classrooms.size).to eq(2)
    end

    it 'returns student classrooms' do
      expect(student_a.attending_classrooms).to include(classroom1)
      expect(student_a.attending_classrooms).to include(classroom2)
      expect(student_a.attending_classrooms.size).to eq(2)
    end
  end
end
