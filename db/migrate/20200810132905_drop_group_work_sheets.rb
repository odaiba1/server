class DropGroupWorkSheets < ActiveRecord::Migration[6.0]
  def change
    drop_table :group_work_sheets
  end
end
