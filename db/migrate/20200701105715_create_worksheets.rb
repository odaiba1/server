class CreateWorksheets < ActiveRecord::Migration[6.0]
  def change
    create_table :worksheets do |t|
      t.json :display_content
      t.json :correct_content

      t.timestamps
    end
  end
end
