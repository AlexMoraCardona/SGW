class CreateProtectionElements < ActiveRecord::Migration[7.0]
  def change
    create_table :protection_elements do |t|
      t.string :name
      t.string :body_protect
      t.string :rule_protection
      t.string :durability
      t.integer :date_sheet, default: 0
      t.integer :delivery_format, default: 0
      t.integer :personal_induction, default: 0
      t.integer :state_protection, default: 0

      t.timestamps
    end
  end
end
