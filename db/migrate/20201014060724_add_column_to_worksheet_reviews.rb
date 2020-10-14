class AddColumnToWorksheetReviews < ActiveRecord::Migration[6.0]
  def change
    add_reference :worksheet_reviews, :worksheet, null: false, foreign_key: true
  end
end
