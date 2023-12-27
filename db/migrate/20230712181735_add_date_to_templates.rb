class AddDateToTemplates < ActiveRecord::Migration[7.0]
  def change
    add_column :templates, :date, :date
    add_column :templates, :version, :integer, default: 0
    add_column :templates, :state, :integer, default: 0
  end
end
