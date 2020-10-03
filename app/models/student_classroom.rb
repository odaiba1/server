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
  
  validates :user, uniqueness: { scope: :classroom,
    message: "should not add the same student to the classroom multiple times" }
  validate :user_role

  private

  def user_role
    errors.add(:not_authorized, 'Teachers cannot create studen classrooms') if user&.teacher?
  end
end
