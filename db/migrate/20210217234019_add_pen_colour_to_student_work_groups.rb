class AddPenColourToStudentWorkGroups < ActiveRecord::Migration[6.1]
  def change
    add_column :student_work_groups, :pen_colour, :string, default: '#000000'
  end
end
