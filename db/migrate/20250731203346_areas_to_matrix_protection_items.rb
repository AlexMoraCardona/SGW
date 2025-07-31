class AreasToMatrixProtectionItems < ActiveRecord::Migration[7.0]
  def change 
    add_column :matrix_protection_items, :areas, :string
  end  
end
