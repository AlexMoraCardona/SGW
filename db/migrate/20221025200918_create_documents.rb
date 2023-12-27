class CreateDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :documents do |t|
      t.string :document_type
      t.integer :code
      t.string :abbreviation

      t.timestamps
    end
    add_index :documents, :code, unique: true
  end
end
