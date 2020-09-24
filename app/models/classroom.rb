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
class Classroom < ApplicationRecord
  alias_attribute :students, :users
  alias_attribute :teacher, :user

  belongs_to :user
  has_many :work_groups, dependent: :destroy
  has_many :student_classrooms
  has_many :users, through: :student_classrooms

  validates :name, presence: true
  validate :user_role
  validate :start_time_after_current_time
  validate :end_time_after_start_time

  def class_time
    formatted_time_str = start_time.strftime("%k:%M") + " - " + end_time.strftime("%k:%M")
  end

  private

  def user_role
    errors.add(:not_authorized, 'Students cannot create classrooms') if user&.student?
  end

  def start_time_after_current_time
    return if start_time.nil?

    errors.add(:start_time, 'must not be in the past') if Time.now >= start_time
  end

  def end_time_after_start_time
    return if end_time.nil?

    errors.add(:end_time, ' must not be before start time') if end_time <= start_time
  end
end
