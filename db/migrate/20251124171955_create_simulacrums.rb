class CreateSimulacrums < ActiveRecord::Migration[7.0]
  def change
    create_table :simulacrums do |t|
      t.date :date_simulacrum
      t.integer :year, default: 0
      t.integer :user_asesor, default: 0
      t.date :date_user_asesor
      t.integer :firm_user_asesor, default: 0
      t.time :time_simulacrum
      t.string :municipality
      t.string :preparation
      t.string :type_emergency
      t.time :time_warning_signal
      t.time :time_alarm_signal
      t.time :time_arrival
      t.string :support_group
      t.string :cel_emergency
      t.string :conclusions
      t.string :recommendations

      t.timestamps
    end
    add_reference :simulacrums, :entity, null: true, foreign_key: true
  end
end
