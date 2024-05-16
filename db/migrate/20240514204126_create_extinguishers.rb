class CreateExtinguishers < ActiveRecord::Migration[7.0]
  def change
    create_table :extinguishers do |t|
      t.date :date_creation
      t.string :area
      t.integer :nro, default: 0
      t.integer :type_extinguisher, default: 0
      t.integer :ability, default: 0
      t.integer :ring, default: 0
      t.integer :pressure_gauge, default: 0
      t.integer :barrette, default: 0
      t.integer :handle, default: 0
      t.integer :valve, default: 0
      t.integer :hose, default: 0
      t.integer :nozzle, default: 0
      t.integer :cylindrical_body, default: 0
      t.integer :decal, default: 0
      t.integer :medium, default: 0
      t.integer :signaling, default: 0
      t.integer :location, default: 0
      t.string :area_location
      t.date :date_carga
      t.date :date_vec_carga
      t.string :observation
      t.integer :firm_user, default: 0
      t.date :date_firm_user

      t.timestamps
    end
    add_reference :extinguishers, :entity, null: true, foreign_key: true
    add_reference :extinguishers, :user, null: true, foreign_key: true
  end
end
