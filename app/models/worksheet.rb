# == Schema Information
#
# Table name: worksheets
#
#  id                    :bigint           not null, primary key
#  canvas                :string
#  name                  :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  work_group_id         :bigint
#  worksheet_template_id :bigint
#
# Indexes
#
#  index_worksheets_on_work_group_id          (work_group_id)
#  index_worksheets_on_worksheet_template_id  (worksheet_template_id)
#
# Foreign Keys
#
#  fk_rails_...  (work_group_id => work_groups.id)
#  fk_rails_...  (worksheet_template_id => worksheet_templates.id)
#
class Worksheet < ApplicationRecord
  has_many :group_work_sheets
  has_many :work_groups, through: :group_work_sheets
end
