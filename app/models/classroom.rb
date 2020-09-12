# == Schema Information
#
# Table name: classrooms
#
#  id         :bigint           not null, primary key
#  grade      :integer
#  group      :string
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
class Classroom < ApplicationRecord
  alias_attribute :students, :users
  alias_attribute :teacher, :user

  belongs_to :user
  has_many :work_groups, dependent: :destroy
  has_many :student_classrooms
  has_many :users, through: :student_classrooms

  validates :subject, :group, presence: true
  validate :user_role

  def parse_for_dashboard
    {
      id: self.id,
      subject: self.subject,
      group: self.group,
      teacher: self.user.name,
      color: self.get_color,
      link: '#'
    }
  end

  def get_color
    case self.subject
    when 'English'
      'blue'
    when 'Maths'
      'green'
    when 'Science'
      'yellow'
    when 'Geography'
      'purple'
    when 'History'
      'red'
    else
      'blue'
    end
  end

  private

  def user_role
    errors.add(:not_authorized, 'Students cannot create classrooms') if user&.student?
  end
end
