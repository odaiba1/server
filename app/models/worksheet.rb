# == Schema Information
#
# Table name: worksheets
#
#  id                    :bigint           not null, primary key
#  canvas                :string
#  title                 :string
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
  belongs_to :worksheet_template
  belongs_to :work_group

  has_one_attached :photo
end
