class CreateMatrixUnsafes < ActiveRecord::Migration[7.0]
  def change
    create_table :matrix_unsafes do |t|
      t.date :date_unsafe
      t.integer :user_representante, default: 0
      t.integer :user_responsible, default: 0
      t.date :date_firm_representante
      t.date :date_firm_responsible
      t.integer :firm_representante, default: 0
      t.integer :firm_responsible, default: 0

      t.timestamps
    end
    add_reference :matrix_unsafes, :entity, null: true, foreign_key: true
  end
end
