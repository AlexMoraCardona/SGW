class AddConservationTimeToTemplates < ActiveRecord::Migration[7.0]
  def change
    add_column :templates, :conservation_time, :text
    add_column :templates, :ubication_document, :text
    add_column :templates, :medium_storage, :text
  end
end
