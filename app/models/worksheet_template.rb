# == Schema Information
#
# Table name: worksheet_templates
#
#  id         :bigint           not null, primary key
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

  has_one_attached :photo
end
