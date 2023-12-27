class CreateAnnualWorkPlans < ActiveRecord::Migration[7.0]
  def change
    create_table :annual_work_plans do |t|
      t.integer :year
      t.integer :user_legal_representative
      t.integer :user_adviser_sst
      t.integer :user_responsible_sst
      t.integer :version
      t.string :code

      t.timestamps
    end
    add_reference :annual_work_plans, :entity, null: true, foreign_key: true
  end
end
