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
  validate :url_is_an_image

  private

  def user_role
    errors.add(:user_role, 'Students cannot create worksheet templates') if user&.student?
  end

  def url_is_an_image
    return unless image_url

    accepted_suffixes = %w[jpg jpeg png]
    accepted = accepted_suffixes.include?(image_url.split('.').last)
    errors.add(:url_is_an_image, 'Please insert a valid image url') unless accepted
  end
end
