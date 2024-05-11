class CreateWorkingConditions < ActiveRecord::Migration[7.0]
  def change
    create_table :working_conditions do |t|
      t.date :date_creation
      t.integer :sex, default: 0
      t.integer :age, default: 0
      t.integer :civil_status, default: 0
      t.string :post
      t.string :area
      t.string :equipment_operates
      t.integer :epp, default: 0
      t.string :epp_cuales
      t.string :control_proposal
      t.date :date_firm_user
      t.integer :firm_user, default: 0

      t.timestamps
    end
    add_reference :working_conditions, :user, null: true, foreign_key: true
    add_reference :working_conditions, :entity, null: true, foreign_key: true
  end
end
