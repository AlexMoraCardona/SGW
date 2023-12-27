class CreateHistoryMatrixLegals < ActiveRecord::Migration[7.0]
  def change
    create_table :history_matrix_legals do |t|
      t.date :date_create
      t.integer :user_legal_representative
      t.integer :user_adviser_sst
      t.integer :user_responsible_sst

      t.timestamps
    end
    add_reference :history_matrix_legals, :matrix_legal, null: true, foreign_key: true
    add_reference :history_matrix_legals, :entity, null: true, foreign_key: true

  end
end
