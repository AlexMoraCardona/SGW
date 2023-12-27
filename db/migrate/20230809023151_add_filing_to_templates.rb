class AddFilingToTemplates < ActiveRecord::Migration[7.0]
  def change
    add_column :templates, :filing, :string 
  end
end
