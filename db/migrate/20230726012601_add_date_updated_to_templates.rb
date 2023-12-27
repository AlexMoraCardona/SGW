class AddDateUpdatedToTemplates < ActiveRecord::Migration[7.0]
  def change
    add_column :templates, :date_updated, :date
  end
end
