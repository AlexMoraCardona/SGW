class CreateProvidesProtectionItems < ActiveRecord::Migration[7.0]
  def change
    create_table :provides_protection_items do |t|
      t.integer :cant, default: 0
      t.date :date_entrega
      t.integer :num, default: 0

      t.timestamps
    end
    add_reference :provides_protection_items, :provides_protection, null: true, foreign_key: true
    add_reference :provides_protection_items, :protection_element, null: true, foreign_key: true

  end
end
