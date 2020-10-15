class CreateWorksheetReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :worksheet_reviews do |t|
      t.text :content
      t.references :user, null: false, foreign_key: true
      t.references :worksheet, null: false, foreign_key: true
    end
  end
end
