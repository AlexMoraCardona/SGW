class CreateDetailDiseases < ActiveRecord::Migration[7.0]
  def change
    create_table :detail_diseases do |t|
      t.string :name
      t.string :code_disease

      t.timestamps
    end
    add_reference :detail_diseases, :table_disease, null: true, foreign_key: true
  end
end
