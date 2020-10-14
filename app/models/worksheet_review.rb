# == Schema Information
#
# Table name: worksheet_reviews
#
#  id           :bigint           not null, primary key
#  content      :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#  worksheet_id :bigint           not null
#
# Indexes
#
#  index_worksheet_reviews_on_user_id       (user_id)
#  index_worksheet_reviews_on_worksheet_id  (worksheet_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#  fk_rails_...  (worksheet_id => worksheets.id)
#
class WorksheetReview < ApplicationRecord
  belongs_to :user
  belongs_to :worksheet

  validates :content, :user, :worksheet, presence: true

  def teacher
    self.worksheet.work_group.classroom.user
  end
end
