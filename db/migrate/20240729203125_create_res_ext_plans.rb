class CreateResExtPlans < ActiveRecord::Migration[7.0]
  def change
    create_table :res_ext_plans do |t|
      t.string :name
      t.string :place
      t.string :phone
      t.integer :cant, default: 0

      t.timestamps
    end
    add_reference :res_ext_plans, :emergency_plan, null: true, foreign_key: true

  end
end
