class RemoveNameFromClassrooms < ActiveRecord::Migration[6.0]
  def change
    remove_column :classrooms, :name, :string
  end
end
