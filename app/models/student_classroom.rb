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
class StudentClassroom < ApplicationRecord
  alias_attribute :student, :user

  belongs_to :user
  belongs_to :classroom
  validate :is_student, on: :create 
 
  def is_student
    user = User.find_by_id(user_id)
    if user.nil? || user.teacher?
      errors.add(:not_student, "Only a Student can create a Student Classroom")
    end
  end
end
