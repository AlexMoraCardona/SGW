class CreateEquipementUsedPlans < ActiveRecord::Migration[7.0]
  def change
    create_table :equipement_used_plans do |t|
      t.integer :type_equipement, default: 0
      t.string :name

      t.timestamps
    end
    add_reference :equipement_used_plans, :emergency_plan, null: true, foreign_key: true
    
  end
end
