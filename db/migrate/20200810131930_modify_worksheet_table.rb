class ModifyWorksheetTable < ActiveRecord::Migration[6.0]
  def change
    remove_column :worksheets, :correct_content
    remove_column :worksheets, :display_content
    add_column :worksheets, :canvas, :string
    add_reference :worksheets, :worksheet_template, index: true
    add_reference :worksheets, :work_group, index: true
    add_foreign_key :worksheets, :worksheet_templates
    add_foreign_key :worksheets, :work_groups
  end
end
