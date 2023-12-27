class AddAplicaToStandarDetailItems < ActiveRecord::Migration[7.0]
  def change
    add_column :standar_detail_items, :aplica, :integer, default: 0
  end
end
