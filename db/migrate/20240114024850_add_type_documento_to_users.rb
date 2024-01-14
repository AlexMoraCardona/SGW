class AddTypeDocumentoToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :legal_representative, :integer, default: 0
    add_column :users, :copasst, :integer, default: 0
    add_column :users, :ccl, :integer, default: 0
    add_column :users, :collaborator, :integer, default: 0
    add_column :entities, :responsible_sst, :integer, default: 0
    add_reference :users, :document, null: true, foreign_key: true
  end
end
