# == Schema Information
#
# Table name: work_groups
#
#  id                   :bigint           not null, primary key
#  aasm_state           :string
#  answered             :integer
#  name                 :string
#  score                :integer
#  session_time         :integer
#  start_at             :datetime
#  turn_time            :integer
#  video_call_code      :string
#  worksheet_email_sent :boolean          default(FALSE)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  classroom_id         :bigint           not null
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
    state :created, initial: true
    state :in_progress
    state :done
    state :canceled

    event :initiate do
      transitions from: :created, to: :in_progress
    end

    event :conclude do
      transitions from: :in_progress, to: :done
    end

    event :cancel do
      transitions from: %i[created in_progress], to: :canceled
    end
  end

  alias_attribute :students, :users

  belongs_to :classroom
  has_many :worksheets
  has_many :student_work_groups
  has_many :users, through: :student_work_groups

  validates :aasm_state, :video_call_code, :turn_time, presence: true
  validate :start_time_after_current_time
  validate :turn_time_less_than_session_time

  scope :active_groups, -> { where(aasm_state: 'in_progress') }

  def minified_url(user)
    one_time_password = rand(36**10).to_s(36)
    user.update(password: one_time_password)
    url_suffix = "/classrooms/#{classroom_id}/work_groups/#{id}?email=#{user.email}&password=#{one_time_password}"
    if Rails.env == 'production'
      url = 'https://odaiba-app.netlify.app' + url_suffix
      LinkShortener.new(url).call
    else
      'http://localhost:3000' + url_suffix
    end
  end

  private

  def start_time_after_current_time
    return if start_at.nil?

    errors.add(:start_at, 'Start time must not be in the past') if Time.now >= start_at
  end

  def turn_time_less_than_session_time
    return if turn_time.nil? || session_time.nil?

    errors.add(:turn_time, 'Must be less than session time') if turn_time >= session_time
  end
end
