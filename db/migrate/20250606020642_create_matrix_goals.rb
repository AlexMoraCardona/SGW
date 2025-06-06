class CreateMatrixGoals < ActiveRecord::Migration[7.0]
  def change
    create_table :matrix_goals do |t|
      t.date :date_unsafe
      t.integer :user_representante, default: 0
      t.integer :user_responsible, default: 0
      t.integer :user_asesor, default: 0
      t.date :date_firm_representante
      t.date :date_firm_responsible
      t.date :date_firm_asesor
      t.integer :firm_representante, default: 0
      t.integer :firm_responsible, default: 0
      t.integer :firm_asesor, default: 0
      t.integer :year, default: 0

      t.timestamps
    end
    add_reference :matrix_goals, :entity, null: true, foreign_key: true
  end
end
