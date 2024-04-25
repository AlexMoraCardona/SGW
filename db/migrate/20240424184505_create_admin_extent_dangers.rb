class CreateAdminExtentDangers < ActiveRecord::Migration[7.0]
  def change
    create_table :admin_extent_dangers do |t|
      t.date :date_creation
      t.date :date_vencimiento
      t.integer :state_extent, default: 0

      t.timestamps
    end
    add_reference :admin_extent_dangers, :entity, null: true, foreign_key: true
  end
end
