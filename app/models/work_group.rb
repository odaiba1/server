# == Schema Information
#
# Table name: work_groups
#
#  id              :bigint           not null, primary key
#  aasm_state      :string
#  answered        :integer
#  name            :string
#  score           :integer
#  session_time    :integer
#  start_at        :datetime
#  turn_time       :integer
#  video_call_code :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  classroom_id    :bigint           not null
#
# Indexes
#
#  index_work_groups_on_classroom_id  (classroom_id)
#
# Foreign Keys
#
#  fk_rails_...  (classroom_id => classrooms.id)
#
class WorkGroup < ApplicationRecord
  include AASM

  aasm do
    state :next_up
    state :in_progress
    state :done
    state :canceled

    event :proceed do
      transitions from: :next_up, to: :in_progress
      transitions from: :in_progress, to: :done
    end

    event :cancel do
      transitions from: %i[next_up in_progress], to: :canceled
    end
  end
  alias_attribute :students, :users

  belongs_to :classroom
  has_many :worksheets
  has_many :student_work_groups
  has_many :users, through: :student_work_groups
end
