class CreateAdmExtinguishers < ActiveRecord::Migration[7.0]
  def change
    create_table :adm_extinguishers do |t|
      t.integer :firm_user, default: 0
      t.date :date_firm_user
      t.date :date_creation
      t.string :area

      t.timestamps
    end
    add_reference :adm_extinguishers, :entity, null: true, foreign_key: true
    add_reference :adm_extinguishers, :user, null: true, foreign_key: true
    add_reference :extinguishers, :adm_extinguisher, null: true, foreign_key: true
  end
end
