# == Schema Information
#
# Table name: classrooms
#
#  id         :bigint           not null, primary key
#  name       :string
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
class Classroom < ApplicationRecord
  alias_attribute :students, :users
  alias_attribute :teacher, :user

  belongs_to :user
  has_many :work_groups, dependent: :destroy
  has_many :student_classrooms
  has_many :users, through: :student_classrooms

  validates :name, presence: true
  validate :is_teacher, on: :create 
 
  def is_teacher
    if user.nil? || user.student?
      errors.add(:not_teacher, "Only a Teacher can create a Classroom")
    end
  end
end
