class ChangeColumnDeficiencylevelToMatixDangerItems < ActiveRecord::Migration[7.0]
  def change
    change_column :matrix_danger_items, :deficiency_level, :integer
    change_column :matrix_danger_items, :exposure_level, :integer
    change_column :matrix_danger_items, :probability_level, :integer
    change_column :matrix_danger_items, :consequence_level, :integer
    change_column :matrix_danger_items, :level_risk_intervention, :integer
    change_column :matrix_danger_items, :intervention_measures_elimination, :string
    change_column :matrix_danger_items, :intervention_measures_replacement, :string
    
  end
end
