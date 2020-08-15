class AddImageUrlColumns < ActiveRecord::Migration[6.0]
  def change
    add_column :worksheets, :image_url, :string
    add_column :worksheet_templates, :image_url, :string
  end
end
