class CreateResourceItems < ActiveRecord::Migration[7.0]
  def change
    create_table :resource_items do |t|
      t.integer :consecutive, default: 0
      t.string :process
      t.string :activity
      t.string :responsible
      t.integer :value, default: 0
      t.integer :executed, default: 0
      t.integer :approved, default: 0
      t.date :date_approved

      t.timestamps
    end
    add_reference :resource_items, :resource, null: true, foreign_key: true
  end
end
