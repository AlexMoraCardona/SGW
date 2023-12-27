class CreateLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :locations do |t|
      t.integer :phone_number_entity
      t.integer :cell_entity
      t.string :entity_address
      t.integer :entity_location_code, default: 0
      t.string :entity_zone
      t.integer :number_workers
      t.string :name_locate
      t.string :code_locate

      t.timestamps
    end
    add_reference :locations, :entity, null: true, foreign_key: true
  end
end
