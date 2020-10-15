# == Schema Information
#
# Table name: worksheet_reviews
#
#  id           :bigint           not null, primary key
#  content      :text
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

  validates :content, presence: true

  def teacher
    worksheet.work_group.classroom.teacher
  end
end
