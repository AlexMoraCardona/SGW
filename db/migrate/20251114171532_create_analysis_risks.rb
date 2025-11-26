class CreateAnalysisRisks < ActiveRecord::Migration[7.0]
  def change
    create_table :analysis_risks do |t|
      t.date :date_analysis
      t.integer :code_area, default: 0
      t.string :description_activity
      t.integer :routine_activity, default: 0
      t.string :epp_requested
      t.string :accident
      t.string :history
      t.string :tools_use
      t.string :training_activity
      t.string :activity_standar
      t.string :observations
      t.integer :user_elaborated, default: 0
      t.date :date_user_elaborated
      t.integer :firm_user_elaborated, default: 0

      t.timestamps
    end
    add_reference :analysis_risks, :entity, null: true, foreign_key: true
  end
end
