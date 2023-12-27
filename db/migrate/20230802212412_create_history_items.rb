class CreateHistoryItems < ActiveRecord::Migration[7.0]
  def change
    create_table :history_items do |t|
      t.decimal :score, default: 0
      t.string :description
      t.string :observation
      t.integer :meets, default: 0
      t.integer :apply, default: 0
      t.integer :cycle, default: 0
      t.string :item_nro
      t.integer :order_nro, default: 0

      t.timestamps
    end
  end
end
