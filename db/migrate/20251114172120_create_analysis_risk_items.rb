class CreateAnalysisRiskItems < ActiveRecord::Migration[7.0]
  def change
    create_table :analysis_risk_items do |t|
      t.string :basic_steps
      t.string :actions_steps
      t.string :risks_steps
      t.string :measures_steps

      t.timestamps
    end
    add_reference :analysis_risk_items, :analysis_risk, null: true, foreign_key: true
  end
end
