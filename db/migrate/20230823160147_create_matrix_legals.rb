class CreateMatrixLegals < ActiveRecord::Migration[7.0]
  def change
    create_table :matrix_legals do |t|
      t.date :date_create
      t.date :date_update
      t.integer :user_legal_representative, default: 0
      t.integer :user_adviser_sst, default: 0
      t.integer :user_responsible_sst, default: 0
      t.integer :consecutive, default: 0
      t.string :risk_factor
      t.string :issuing_entity
      t.string :requirement
      t.string :rule_name
      t.string :applicable_article
      t.integer :apply, default: 0
      t.string :evidence_compliance
      t.string :responsible
      t.integer :meets, default: 0
      t.string :description_compliance

      t.timestamps
    end
    add_reference :matrix_legals, :entity, null: true, foreign_key: true

  end
end
