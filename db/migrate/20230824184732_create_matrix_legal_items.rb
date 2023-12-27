class CreateMatrixLegalItems < ActiveRecord::Migration[7.0]
  def change
    create_table :matrix_legal_items do |t|
      t.integer :consecutive
      t.string :risk_factor
      t.string :issuing_entity
      t.string :requirement
      t.string :rule_name
      t.string :applicable_article
      t.integer :apply
      t.string :evidence_compliance
      t.string :responsible
      t.integer :meets
      t.string :description_compliance

      t.timestamps
    end
    add_reference :matrix_legal_items, :matrix_legal, null: true, foreign_key: true

  end
end
