class CreateMatrixDangerItems < ActiveRecord::Migration[7.0]
  def change
    create_table :matrix_danger_items do |t|
      t.integer :consecutive, default: 0
      t.integer :year, default: 0
      t.string :source_information
      t.string :activity
      t.string :task
      t.integer :type_task, default: 0
      t.string :origin
      t.string :possible_effects_health
      t.string :possible_effects_security
      t.string :description_existing_control_origin
      t.string :description_existing_control_medium
      t.string :description_existing_control_person
      t.string :description_existing_control_observations
      t.decimal :deficiency_level, default: 0
      t.decimal :exposure_level, default: 0
      t.decimal :probability_level, default: 0
      t.string :interpretation
      t.decimal :consequence_level, default: 0
      t.decimal :level_risk_intervention, default: 0
      t.string :risk_level_interpretation
      t.string :risk_acceptability
      t.integer :number_exposed, default: 0
      t.integer :hours_exposure, default: 0
      t.string :worst_consequence
      t.integer :existence_legal_requirement, default: 0
      t.integer :intervention_measures_elimination, default: 0
      t.integer :intervention_measures_replacement, default: 0
      t.string :intervention_measures_engineering_control
      t.string :intervention_measures_acsw
      t.string :intervention_measures_ppee
      t.string :responsible_implementation
      t.string :type_register
      t.date :proposed_date
      t.date :implementation_date
      t.date :follow_date
      t.string :observations

      t.timestamps
    end
    add_reference :matrix_danger_items, :matrix_danger_risk, null: true, foreign_key: true    
    add_reference :matrix_danger_items, :clasification_danger, null: true, foreign_key: true    
    add_reference :matrix_danger_items, :clasification_danger_detail, null: true, foreign_key: true    
  end
end
