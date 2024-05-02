class CreateMatrixProtectionItems < ActiveRecord::Migration[7.0]
  def change
    create_table :matrix_protection_items do |t|
      t.integer :num, default: 0
      t.string :durability
      t.integer :date_sheet, default: 0
      t.integer :delivery_format, default: 0
      t.integer :personal_induction, default: 0
      t.integer :state_protection, default: 0

      t.timestamps
    end
    add_reference :matrix_protection_items, :matrix_protection, null: true, foreign_key: true
    add_reference :matrix_protection_items, :protection_element, null: true, foreign_key: true
  end
end
