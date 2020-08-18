# == Schema Information
#
# Table name: student_work_groups
#
#  id            :bigint           not null, primary key
#  joined        :boolean
#  turn          :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint           not null
#  work_group_id :bigint           not null
#
# Indexes
#
#  index_student_work_groups_on_user_id        (user_id)
#  index_student_work_groups_on_work_group_id  (work_group_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#  fk_rails_...  (work_group_id => work_groups.id)
#
class StudentWorkGroup < ApplicationRecord
  alias_attribute :student, :user

  belongs_to :user
  belongs_to :work_group

  validate :user_role

  private

  def user_role
    errors.add(:not_student, 'Teachers cannot create Student Work Groups') if user&.teacher?
  end
end
