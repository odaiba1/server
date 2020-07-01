class AddAasmStateToWorkGroups < ActiveRecord::Migration[6.0]
  def change
    add_column :work_groups, :aasm_state, :string
  end
end
