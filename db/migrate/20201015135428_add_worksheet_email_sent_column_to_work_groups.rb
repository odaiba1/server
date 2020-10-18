class AddWorksheetEmailSentColumnToWorkGroups < ActiveRecord::Migration[6.0]
  def change
    add_column :work_groups, :worksheet_email_sent, :boolean, default: false
  end
end
