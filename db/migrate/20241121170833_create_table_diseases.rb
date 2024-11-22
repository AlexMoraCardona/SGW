class CreateTableDiseases < ActiveRecord::Migration[7.0]
  def change
    create_table :table_diseases do |t|
      t.string :clasification_disease

      t.timestamps
    end
  end
end
