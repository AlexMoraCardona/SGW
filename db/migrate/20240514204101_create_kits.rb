class CreateKits < ActiveRecord::Migration[7.0]
  def change
    create_table :kits do |t|
      t.date :date_creation
      t.string :area
      t.integer :type_kit, default: 0
      t.integer :clasification_kit, default: 0
      t.integer :gauze, default: 0
      t.string :gauze_obs
      t.integer :sticking_plaster, default: 0
      t.string :sticking_plaster_obs
      t.integer :tongue_depressor, default: 0
      t.string :tongue_depressor_obs
      t.integer :gloves, default: 0
      t.string :gloves_obs
      t.integer :elastic_bandage25, default: 0
      t.string :elastic_bandage25_obs
      t.integer :elastic_bandage55, default: 0
      t.string :elastic_bandage55_obs
      t.integer :sell_cotton35, default: 0
      t.string :sell_cotton35_obs
      t.integer :sell_cotton55, default: 0
      t.string :sell_cotton55_obs
      t.integer :soap, default: 0
      t.string :soap_obs
      t.integer :saline_solution, default: 0
      t.string :saline_solution_obs
      t.integer :thermometer, default: 0
      t.string :thermometer_obs
      t.integer :alcohol, default: 0
      t.string :alcohol_obs
      t.integer :sterile_gauze, default: 0
      t.string :sterile_gauze_obs
      t.integer :dressing, default: 0
      t.string :dressing_obs
      t.integer :scissors, default: 0
      t.string :scissors_obs
      t.integer :flashlight, default: 0
      t.string :flashlight_obs
      t.integer :batteries, default: 0
      t.string :batteries_obs
      t.integer :spinal_board, default: 0
      t.string :spinal_board_obs
      t.integer :adult_cervical_collar, default: 0
      t.string :adult_cervical_collar_obs
      t.integer :child_cervical_collar, default: 0
      t.string :child_cervical_collar_obs
      t.integer :adult_immobilizers_top, default: 0
      t.string :adult_immobilizers_top_obs
      t.integer :adult_immobilizers_lower, default: 0
      t.string :adult_immobilizers_lower_obs
      t.integer :child_immobilizers_top, default: 0
      t.string :child_immobilizers_top_obs
      t.integer :child_immobilizers_lower, default: 0
      t.string :child_immobilizers_lower_obs
      t.integer :disposable_cups, default: 0
      t.string :disposable_cups_obs
      t.integer :lood_pressure_monitor, default: 0
      t.string :lood_pressure_monitor_obs
      t.integer :stethoscope, default: 0
      t.string :stethoscope_obs
      t.integer :mask_rcp, default: 0
      t.string :mask_rcp_obs
      t.integer :firm_user, default: 0
      t.date :date_firm_user
      t.string :post

      t.timestamps
    end
    add_reference :kits, :entity, null: true, foreign_key: true
    add_reference :kits, :user, null: true, foreign_key: true
  end
end
