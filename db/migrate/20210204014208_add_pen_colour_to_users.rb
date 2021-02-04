class AddPenColourToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :pen_colour, :string, default: '#000000'
  end
end
