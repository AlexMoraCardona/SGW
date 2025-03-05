class TypeDocumentToTemplate < ActiveRecord::Migration[7.0]
  def change
    add_column :templates, :type_document, :integer, default: 0
    add_column :templates, :process_document, :integer, default: 0
    add_column :templates, :type_soport, :integer, default: 0
    add_column :templates, :name_dependence, :integer, default: 0
    add_column :templates, :observations, :string
    add_column :templates, :dependence_admin, :integer, default: 0
    add_column :templates, :control_changes, :string
    add_column :templates, :not_current, :date
  end
end
