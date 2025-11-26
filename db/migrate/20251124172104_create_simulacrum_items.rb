class CreateSimulacrumItems < ActiveRecord::Migration[7.0]
  def change
    create_table :simulacrum_items do |t|
      t.integer :clasification, default: 0
      t.string :name
      t.string :position_exercise
      t.string :area_work
      t.string :functions
      t.string :floor
      t.string :evacuated_personal_area
      t.string :evacuated_personal_name
      t.string :evacuated_personal_cargo
      t.string :previous_activity
      t.date :date_previous
      t.string :responsible_previous
      t.time :time_sequence_crono
      t.string :activity_sequence

      t.timestamps
    end
    add_reference :simulacrum_items, :simulacrum, null: true, foreign_key: true
  end
end
