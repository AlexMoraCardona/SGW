class CreateBrigadistaPlans < ActiveRecord::Migration[7.0]
  def change
    create_table :brigadista_plans do |t|
      t.string :name_brigadista
      t.string :perfil_brigadista

      t.timestamps
    end
    add_reference :brigadista_plans, :emergency_plan, null: true, foreign_key: true
  end
end
