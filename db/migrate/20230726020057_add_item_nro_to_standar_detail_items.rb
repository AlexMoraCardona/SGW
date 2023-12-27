class AddItemNroToStandarDetailItems < ActiveRecord::Migration[7.0]
  def change
    add_column :standar_detail_items, :item_nro, :string
    add_column :standar_detail_items, :order_nro, :integer, default: 0
  end
end
