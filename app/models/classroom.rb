# == Schema Information
#
# Table name: classrooms
#
#  id         :bigint           not null, primary key
#  end_time   :datetime
#  grade      :integer
#  group      :string
#  start_time :datetime
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

  # OPTIMIZE: add AASM state?

  belongs_to :user
  has_many :work_groups, dependent: :destroy
  has_many :student_classrooms
  has_many :users, through: :student_classrooms

  validates :subject, :group, :grade, presence: true
  validate :user_role
  validate :start_time_after_current_time
  validate :end_time_after_start_time

  def parse_for_dashboard
    {
      id: id,
      subject: subject,
      group: group,
      teacher: user.name,
      color: subject_color,
      link: '#',
      classTime: class_time # CamelCase used because this will be primarily used on the frontent
    }
  end

  def subject_color
    case subject
    when 'English' then 'blue'
    when 'Maths' then 'green'
    when 'Science' then 'yellow'
    when 'Geography' then 'purple'
    when 'History' then 'red'
    else
      'blue'
    end
  end

  def name
    "Grade #{grade} #{subject} Class #{group}"
  end

  def class_time
    return 'Time range not set' if start_time.nil? || end_time.nil?

    start_time.strftime('%H:%M') + ' - ' + end_time.strftime('%H:%M')
  end

  def minified_url_for_teacher(teacher)
    one_time_password = rand(36**10).to_s(36)
    teacher.update(password: one_time_password)
    url_suffix = "/classrooms/#{id}?email=#{teacher.email}&password=#{one_time_password}"
    if Rails.env == 'production'
      url = 'https://odaiba-app.netlify.app' + url_suffix
      LinkShortener.new(url).call
    else
      'http://localhost:3000' + url_suffix
    end
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
    return if end_time.nil? || start_time.nil?

    errors.add(:end_time, ' must not be before start time') if end_time <= start_time
  end
end
