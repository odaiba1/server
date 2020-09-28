class UpdateClassrooms < ActiveRecord::Migration[6.0]
  def change
    remove_column :classrooms, :name, :string
    add_column :classrooms, :subject, :string
    add_column :classrooms, :group, :string
    add_column :classrooms, :grade, :integer
  end
end
