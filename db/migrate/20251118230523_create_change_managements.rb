class CreateChangeManagements < ActiveRecord::Migration[7.0]
  def change
    create_table :change_managements do |t|
      t.date :date_change
      t.integer :code_area, default: 0
      t.string :description_change
      t.string :analisys_change
      t.string :recomendations_change
      t.string :dangers_change
      t.string :requeriment_legal
      t.string :operational_control
      t.string :work_procedure
      t.string :others
      t.integer :user_elaborated, default: 0
      t.date :date_user_elaborated
      t.integer :firm_user_elaborated, default: 0

      t.timestamps
    end
    add_reference :change_managements, :entity, null: true, foreign_key: true
  end
end
