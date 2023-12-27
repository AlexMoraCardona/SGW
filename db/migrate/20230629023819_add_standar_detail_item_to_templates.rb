class AddStandarDetailItemToTemplates < ActiveRecord::Migration[7.0]
  def change
    add_reference :templates, :standar_detail_item, null: false, foreign_key: true
  end
end
