class AddGroupToClassrooms < ActiveRecord::Migration[6.0]
  def change
    add_column :classrooms, :group, :string
  end
end
