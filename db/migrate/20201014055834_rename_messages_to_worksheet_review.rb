class RenameMessagesToWorksheetReview < ActiveRecord::Migration[6.0]
  def change
    rename_table :messages, :worksheet_reviews
  end
end
