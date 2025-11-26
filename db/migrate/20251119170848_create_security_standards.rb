class CreateSecurityStandards < ActiveRecord::Migration[7.0]
  def change
    create_table :security_standards do |t|
      t.integer :code_area, default: 0
      t.date :date_standard
      t.integer :user_elaborated, default: 0
      t.date :date_user_elaborated
      t.integer :firm_user_elaborated, default: 0
      t.string :cargo_user_elaborated
      t.integer :user_asesor, default: 0
      t.date :date_user_asesor
      t.integer :firm_user_asesor, default: 0
      t.string :cargo_user_asesor
      t.string :objetivo
      t.string :danger
      t.integer :type_action, default: 0
      t.string :element_protection
      t.string :description_activity
      t.string :standard_security

      t.timestamps
    end
    add_reference :security_standards, :entity, null: true, foreign_key: true
  end
end
