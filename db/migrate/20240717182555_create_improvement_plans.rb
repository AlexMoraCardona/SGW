class CreateImprovementPlans < ActiveRecord::Migration[7.0]
  def change
    create_table :improvement_plans do |t|
      t.integer :user_representante, default: 0
      t.integer :user_responsible, default: 0
      t.date :date_firm_representante
      t.date :date_firm_responsible
      t.integer :firm_representante, default: 0
      t.integer :firm_responsible, default: 0
      t.date :date_plan
      t.string :activity_plan
      t.integer :action_improvement, default: 0
      t.date :date_initial
      t.date :date_fin
      t.string :aim_improvement

      t.timestamps
    end
    add_reference :improvement_plans, :entity, null: true, foreign_key: true
  end
end
