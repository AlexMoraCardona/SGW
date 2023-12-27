class CreateMatrixDangerRisks < ActiveRecord::Migration[7.0]
  def change
    create_table :matrix_danger_risks do |t|
      t.integer :user_legal_representative
      t.integer :user_adviser_sst
      t.integer :user_responsible_sst
      t.integer :version
      t.string :code

      t.timestamps
    end
    add_reference :matrix_danger_risks, :entity, null: true, foreign_key: true
  end
end
