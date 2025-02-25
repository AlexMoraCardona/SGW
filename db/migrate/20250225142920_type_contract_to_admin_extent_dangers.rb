class TypeContractToAdminExtentDangers < ActiveRecord::Migration[7.0]
  def change
    add_column :admin_extent_dangers, :type_contract, :integer, default: 0
    add_column :admin_extent_dangers, :received_training, :integer, default: 0
    add_column :admin_extent_dangers, :suffered_accident, :integer, default: 0
    add_column :form_preventions, :exposed, :integer, default: 0
  end
end
