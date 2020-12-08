# == Schema Information
#
# Table name: worksheet_templates
#
#  id         :bigint           not null, primary key
#  image_url  :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_worksheet_templates_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class WorksheetTemplate < ApplicationRecord
  belongs_to :user
  has_many :worksheets
  has_many :work_groups, through: :worksheets

  validates :title, :image_url, presence: true
  validate :user_role

  private

  def user_role
    errors.add(:user_role, 'Students cannot create worksheet templates') if user&.student?
  end
end
