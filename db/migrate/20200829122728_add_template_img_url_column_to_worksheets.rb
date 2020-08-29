class AddTemplateImgUrlColumnToWorksheets < ActiveRecord::Migration[6.0]
  # TODO: find a way to fix frontend so it doesn't need this column
  def change
    add_column :worksheets, :template_image_url, :string
  end
end
