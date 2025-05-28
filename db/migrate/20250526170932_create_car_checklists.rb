class CreateCarChecklists < ActiveRecord::Migration[7.0]
  def change
    create_table :car_checklists do |t|
      t.date :date_list
      t.time :time_list
      t.string :plate_car
      t.integer :mileage, default: 0
      t.integer :health_conditions, default: 0
      t.string :health_conditions_obs
      t.integer :tire_condition, default: 0
      t.string :tire_condition_obs
      t.integer :lights_condition, default: 0
      t.string :lights_condition_obs
      t.integer :horn_condition, default: 0
      t.string :horn_condition_obs
      t.integer :mirrors_condition, default: 0
      t.string :mirrors_condition_obs
      t.integer :liquids_condition, default: 0
      t.string :liquids_condition_obs
      t.integer :fluids_condition, default: 0
      t.string :fluids_condition_obs
      t.integer :brakes_condition, default: 0
      t.string :brakes_condition_obs
      t.integer :windshield_condition, default: 0
      t.string :windshield_condition_obs
      t.integer :retention_condition, default: 0
      t.string :retention_condition_obs
      t.integer :documents_condition, default: 0
      t.string :documents_condition_obs
      t.integer :prevention_condition, default: 0
      t.string :prevention_condition_obs
      t.integer :witnesses_condition, default: 0
      t.string :witnesses_condition_obs
      t.integer :firm_user, default: 0
      t.date :date_firm_user
      t.integer :user_autoriza, default: 0
      t.integer :user_autoriza_firm, default: 0
      t.date :user_autoriza_date

      t.timestamps
    end
    add_reference :car_checklists, :user, null: true, foreign_key: true
    add_reference :car_checklists, :entity, null: true, foreign_key: true
  end
end
