class CreateUnsafeConditions < ActiveRecord::Migration[7.0]
  def change
    create_table :unsafe_conditions do |t|
      t.date :date_report
      t.string :place_report
      t.integer :user_reports
      t.string :description_condition
      t.integer :equipment_condition, default: 0
      t.integer :floors_condition, default: 0
      t.integer :not_demarcate_areas, default: 0
      t.integer :gases_dusts, default: 0
      t.integer :unsafe_work_design, default: 0
      t.integer :inadequate_signage, default: 0
      t.integer :defective_tools, default: 0
      t.integer :lack_alarm, default: 0
      t.integer :lack_cleanliness, default: 0
      t.integer :lack_space_work, default: 0
      t.integer :incorrect_storage, default: 0
      t.integer :excessive_noise_levels, default: 0
      t.integer :inadequate_lighting_ventilation, default: 0
      t.string :other_unsafe_conditions
      t.string :description_act_unsafe
      t.integer :not_using_equipment
      t.integer :operating_without_authorization, default: 0
      t.integer :running_facilities, default: 0
      t.integer :using_defective_tool, default: 0
      t.integer :psychoactive_substances, default: 0
      t.integer :ignore_dangerous, default: 0
      t.integer :use_wrong_tool, default: 0
      t.integer :wrong_position, default: 0
      t.integer :heights_without_authorization, default: 0
      t.integer :workplace_distractions, default: 0
      t.integer :gen_on_desk, default: 0
      t.string :other_features
      t.string :alternative_soluctions
      t.integer :user_receiving
      t.integer :user_coordinator
      t.date :date_firm_user_reports
      t.date :date_firm_user_receiving
      t.date :date_firm_user_coordinator
      t.integer :firm_user_reports, default: 0
      t.integer :firm_user_receiving, default: 0
      t.integer :firm_user_coordinator, default: 0

      t.timestamps
    end
    add_reference :unsafe_conditions, :entity, null: true, foreign_key: true
  end
end
