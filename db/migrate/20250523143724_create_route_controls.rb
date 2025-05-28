class CreateRouteControls < ActiveRecord::Migration[7.0]
  def change
    create_table :route_controls do |t|
      t.date :date_control
      t.string :observation
      t.time :time_initial_control
      t.time :time_final_control
      t.string :place
      t.integer :vehicle_type, default: 0

      t.timestamps
    end
    add_reference :route_controls, :user, null: true, foreign_key: true
  end
end
