class CreateMatrixCorrectiveActions < ActiveRecord::Migration[7.0]
  def change
    create_table :matrix_corrective_actions do |t|
      t.integer :user_legal_representative
      t.integer :user_adviser_sst
      t.integer :user_responsible_sst
      t.integer :version
      t.string :code

      t.timestamps
    end
    add_reference :matrix_corrective_actions, :entity, null: true, foreign_key: true
  end
end
