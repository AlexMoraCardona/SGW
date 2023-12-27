class CreateAnnualWorkPlanItems < ActiveRecord::Migration[7.0]
  def change
    create_table :annual_work_plan_items do |t|
      t.integer :consecutive
      t.string :aim
      t.string :goal
      t.string :activity
      t.string :resource
      t.string :responsible
      t.date :date_realization
      t.integer :month
      t.string :observation

      t.timestamps
    end
    add_reference :annual_work_plan_items, :annual_work_plan, null: true, foreign_key: true
  end
end
