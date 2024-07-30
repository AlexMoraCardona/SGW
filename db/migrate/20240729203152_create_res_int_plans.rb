class CreateResIntPlans < ActiveRecord::Migration[7.0]
  def change
    create_table :res_int_plans do |t|
      t.integer :cant, default: 0
      t.string :clase
      t.string :description
      t.string :ubication

      t.timestamps
    end
    add_reference :res_int_plans, :emergency_plan, null: true, foreign_key: true
  end
end
