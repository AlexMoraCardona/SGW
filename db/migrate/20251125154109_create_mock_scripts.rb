class CreateMockScripts < ActiveRecord::Migration[7.0]
  def change
    create_table :mock_scripts do |t|
      t.string :space_for
      t.date :date_script
      t.time :time_script
      t.string :type_emergency
      t.integer :user_representante, default: 0
      t.string :name_coordinator
      t.string :name_brigade
      t.string :name_evacuation
      t.string :external_soport
      t.string :officer_committee
      t.string :coordinator_drill
      t.string :alert_activation
      t.string :evacuation_count
      t.string :evacuation_first
      t.string :evacuation_second
      t.string :withdraw_kit
      t.string :withdraw_stretcher
      t.string :withdraw_extinguisher
      t.string :verification
      t.string :return_indication
      t.string :routes_evacuation
      t.string :emergency_exit
      t.string :emergency_resources
      t.integer :user_asesor, default: 0
      t.date :date_user_asesor
      t.integer :firm_user_asesor, default: 0

      t.timestamps
    end
    add_reference :mock_scripts, :entity, null: true, foreign_key: true
  end
end
