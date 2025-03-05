class DocumentVigenteToTemplate < ActiveRecord::Migration[7.0]
  def change
    add_column :templates, :document_vigente, :integer, default: 1
  end
end
