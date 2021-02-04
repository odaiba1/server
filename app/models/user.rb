# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  authentication_token   :string(30)
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string
#  pen_colour             :string           default("#000000")
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
class User < ApplicationRecord
  acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum role: { student: 0, teacher: 1, admin: 2 }
  validates :role, :name, presence: true
  validates :email, uniqueness: { case_sensitive: false }, presence: true, allow_blank: false

  has_many :student_work_groups
  has_many :work_groups, through: :student_work_groups
  has_many :worksheets, through: :work_groups
  has_many :worksheet_templates
  has_many :classrooms
  has_many :student_classrooms
  has_many :attending_classrooms, through: :student_classrooms, source: :classroom
  has_many :worksheet_reviews, dependent: :destroy

  scope :first_teacher, -> { where(role: 'teacher').first }

  def students
    User.joins(:student_classrooms).where(student_classrooms: { classroom_id: classrooms })
  end

  def teachers
    User.joins(:classrooms).where(classrooms: attending_classrooms)
  end

  def active_student_workgroups
    return unless role == 'student'

    # in the future we should do work_groups.where(aasm_state: 'in_progress')
    work_groups.where("start_at > :time AND start_at - INTERVAL '1 millisecond' * session_time < :time", time: Time.now)
  end
end
