class AddCriterionToStandarDetailItems < ActiveRecord::Migration[7.0]
  def change
    add_column :standar_detail_items, :criterion, :string
    add_column :standar_detail_items, :verification_mode, :string
  end
end
